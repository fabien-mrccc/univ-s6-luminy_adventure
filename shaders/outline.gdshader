shader_type spatial;
render_mode unshaded, blend_mix, depth_draw_never, depth_test_disabled;

/*
	AUTHOR: Hannah "EMBYR" Crawford
	ENGINE_VERSION: 4.0.3

	HOW TO USE:
		1. Create a MeshInstance3D node and place it in your scene.
		2. Set its size to 2x2.
		3. Enable the "Flip Faces" option.
		4. Create a new shader material with this shader.
		5. Assign the material to the MeshInstance3D

	LIMITATIONS:
		Does not work well with TAA enabled.

	MOBILE_NOTES:
		The mobile renderer does not have access to the normal_roughness texture
		so we must rely on techniques to reconstruct this information from the
		depth buffer.

		If you require support on mobile please uncomment the SUPPORT_MOBILE line
		below. I have done my best to match the appearance between the two modes
		however, mobile does not take into account smooth-shaded faces.

		The high-quality reconstruction method used on mobile is rather heavy on
		texture samples. If you would like to use the lower-quality reconstruction
		method for better performance, please uncomment the NAIVE_NORMAL_RECONSTRUCTION
		line below.
*/
//#define SUPPORT_MOBILE
//#define NAIVE_NORMAL_RECONSTRUCTION

group_uniforms outline;
uniform vec4 outline_color: source_color = vec4(0.0, 0.0, 0.0, 0.78);
uniform float depth_threshold = 0.025;
uniform float normal_threshold: hint_range(0.0, 1.5) = 0.5;
uniform float normal_smoothing: hint_range(0.0, 1.0) = 0.25;

group_uniforms thickness;
uniform float max_thickness: hint_range(0.0, 5.0) = 1.3;
uniform float min_thickness = 0.5;
uniform float max_distance = 75.0;
uniform float min_distance = 2.0;

group_uniforms grazing_prevention;
uniform float grazing_fresnel_power = 5.0;
uniform float grazing_angle_mask_power = 1.0;
uniform float grazing_angle_modulation_factor = 50.0;

uniform sampler2D depth_texture: hint_depth_texture, filter_linear, repeat_disable;

#ifndef SUPPORT_MOBILE
uniform sampler2D normr_texture: hint_normal_roughness_texture, filter_linear, repeat_disable;
#else
varying flat mat4 model_view_matrix;
#endif // !SUPPORT_MOBILE

struct uv_neighbors {
	vec2 center;
	vec2 left;     vec2 right;     vec2 up;          vec2 down;
	vec2 top_left; vec2 top_right; vec2 bottom_left; vec2 bottom_right;
};

struct neighbor_depth_samples {
	float c_d;
	float l_d;  float r_d;  float u_d;  float d_d;
	float tl_d; float tr_d; float bl_d; float br_d;
};

uv_neighbors get_neighbors(vec2 center, float width, float aspect) {
	vec2 h_offset = vec2(width * aspect * 0.001, 0.0);
	vec2 v_offset = vec2(0.0, width * 0.001);
	uv_neighbors n;
	n.center = center;
	n.left = center - h_offset;
	n.right = center + h_offset;
	n.up = center - v_offset;
	n.down = center + v_offset;
	n.top_left = center - (h_offset - v_offset);
	n.top_right = center + (h_offset - v_offset);
	n.bottom_left = center - (h_offset + v_offset);
	n.bottom_right = center + (h_offset + v_offset);
	return n;
}

float get_minimum_depth(neighbor_depth_samples ds) {
	return min(ds.c_d, min(ds.l_d, min(ds.r_d, min(ds.u_d, min(ds.d_d, min(ds.tl_d, min(ds.tr_d, min(ds.bl_d, ds.br_d))))))));
}

float get_linear_depth(float depth, vec2 uv, mat4 inv_proj) {
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv_proj * vec4(ndc, 1.0);
	view.xyz /= view.w;
	return -view.z;
}

neighbor_depth_samples get_linear_depth_samples(uv_neighbors uvs, sampler2D depth_tex, mat4 inv_proj_mat) {
	neighbor_depth_samples result;
	result.c_d = get_linear_depth(texture(depth_tex, uvs.center).r, uvs.center, inv_proj_mat);
	result.l_d = get_linear_depth(texture(depth_tex, uvs.left).r, uvs.left, inv_proj_mat);
	result.r_d = get_linear_depth(texture(depth_tex, uvs.right).r, uvs.right, inv_proj_mat);
	result.u_d = get_linear_depth(texture(depth_tex, uvs.up).r, uvs.up, inv_proj_mat);
	result.d_d = get_linear_depth(texture(depth_tex, uvs.down).r, uvs.down, inv_proj_mat);
	result.tl_d = get_linear_depth(texture(depth_tex, uvs.top_left).r, uvs.top_left, inv_proj_mat);
	result.tr_d = get_linear_depth(texture(depth_tex, uvs.top_right).r, uvs.top_right, inv_proj_mat);
	result.bl_d = get_linear_depth(texture(depth_tex, uvs.bottom_left).r, uvs.bottom_left, inv_proj_mat);
	result.br_d = get_linear_depth(texture(depth_tex, uvs.bottom_right).r, uvs.bottom_right, inv_proj_mat);
	return result;
}

float remap(float v, float from1, float to1, float from2, float to2) {
	return (v - from1) / (to1 - from1) * (to2 - from2) + from2;
}

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow((1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0)), amount);
}

float get_grazing_angle_modulation(vec3 pixel_normal, vec3 view) {
	float x = clamp(((fresnel(grazing_fresnel_power, pixel_normal, view) - 1.0) / grazing_angle_mask_power) + 1.0, 0.0, 1.0);
	return (x + grazing_angle_modulation_factor) + 1.0;
}

float detect_edges_depth(neighbor_depth_samples depth_samples, vec3 pixel_normal, vec3 view) {
	float n_total =
		depth_samples.l_d +
		depth_samples.r_d +
		depth_samples.u_d +
		depth_samples.d_d +
		depth_samples.tl_d +
		depth_samples.tr_d +
		depth_samples.bl_d +
		depth_samples.br_d;

	float t = depth_threshold * get_grazing_angle_modulation(pixel_normal, view);
	return step(t, n_total - (depth_samples.c_d * 8.0));
}

// Reconstruction helpers
// Source: https://www.reddit.com/r/godot/comments/v70p2k/improved_normal_from_depth/
#ifdef SUPPORT_MOBILE
vec3 reconstruct_world_position(float depth, mat4 model_view, mat4 inv_proj, vec2 screen_uv, mat4 world, mat4 inv_cam) {
	vec4 pos = inverse(model_view) * inv_proj * vec4((screen_uv * 2.0 - 1.0), depth * 2.0 - 1.0, 1.0);
	pos.xyz /= (pos.w + 0.0001 * (1.0 - abs(sign(pos.w))));
	return (pos * inv_cam).xyz + world[3].xyz;
}

#ifndef NAIVE_NORMAL_RECONSTRUCTION
vec3 reconstruct_world_normal(sampler2D depth_tex, mat4 model_view, mat4 inv_proj, vec2 screen_uv, mat4 world, mat4 inv_cam, vec2 viewport_size) {
	vec2 e = vec2(1.0 / viewport_size);
	float c0 = texture(depth_tex, screen_uv).r;
	float l2 = texture(depth_tex, screen_uv - vec2(2, 0) * e).r;
	float l1 = texture(depth_tex, screen_uv - vec2(1, 0) * e).r;
	float r1 = texture(depth_tex, screen_uv + vec2(1, 0) * e).r;
	float r2 = texture(depth_tex, screen_uv + vec2(2, 0) * e).r;
	float b2 = texture(depth_tex, screen_uv - vec2(0, 2) * e).r;
	float b1 = texture(depth_tex, screen_uv - vec2(0, 1) * e).r;
	float t1 = texture(depth_tex, screen_uv + vec2(0, 1) * e).r;
	float t2 = texture(depth_tex, screen_uv + vec2(0, 2) * e).r;

	float dl = abs(l1 * l2 / (2.0 * l2 - l1) - c0);
	float dr = abs(r1 * r2 / (2.0 * r2 - r1) - c0);
	float db = abs(b1 * b2 / (2.0 * b2 - b1) - c0);
	float dt = abs(t1 * t2 / (2.0 * t2 - t1) - c0);

	vec3 ce = reconstruct_world_position(c0, model_view, inv_proj, screen_uv, world, inv_cam);

	vec3 dpdx = (dl < dr) ? ce - reconstruct_world_position(l1, model_view, inv_proj, screen_uv - vec2(1, 0) * e, world, inv_cam) :
						   -ce + reconstruct_world_position(r1, model_view, inv_proj, screen_uv + vec2(1, 0) * e, world, inv_cam);
	vec3 dpdy = (db < dt) ? ce - reconstruct_world_position(b1, model_view, inv_proj, screen_uv - vec2(0, 1) * e, world, inv_cam) :
						   -ce + reconstruct_world_position(t1, model_view, inv_proj, screen_uv + vec2(0, 1) * e, world, inv_cam);

	return normalize(cross(dpdx, dpdy));
}
#else
vec3 reconstruct_world_normal(sampler2D depth_tex, mat4 model_view, mat4 inv_proj, vec2 screen_uv, mat4 world, mat4 inv_cam, vec2 viewport_size) {
	vec3 pos = reconstruct_world_position(texture(depth_tex, screen_uv).x, model_view, inv_proj, screen_uv, world, inv_cam);
	return normalize(cross(dFdx(pos), dFdy(pos)));
}
#endif // !NAIVE_NORMAL_RECONSTRUCTION

float detect_edges_normal_reconstructed(uv_neighbors uvs, sampler2D depth_tex, mat4 model_view, mat4 inv_proj, vec2 screen_uv, mat4 world, mat4 inv_cam, vec2 viewport_size) {
	vec3 n_u = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.up, world, inv_cam, viewport_size);
	vec3 n_d = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.down, world, inv_cam, viewport_size);
	vec3 n_l = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.left, world, inv_cam, viewport_size);
	vec3 n_r = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.right, world, inv_cam, viewport_size);
	vec3 n_tl = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.top_left, world, inv_cam, viewport_size);
	vec3 n_tr = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.top_right, world, inv_cam, viewport_size);
	vec3 n_bl = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.bottom_left, world, inv_cam, viewport_size);
	vec3 n_br = reconstruct_world_normal(depth_tex, model_view, inv_proj, uvs.bottom_right, world, inv_cam, viewport_size);

	vec3 normal_finite_difference0 = n_tr - n_bl;
	vec3 normal_finite_difference1 = n_tl - n_br;
	vec3 normal_finite_difference2 = n_l - n_r;
	vec3 normal_finite_difference3 = n_u - n_d;

	float edge_normal = sqrt(
		dot(normal_finite_difference0, normal_finite_difference0) +
		dot(normal_finite_difference1, normal_finite_difference1) +
		dot(normal_finite_difference2, normal_finite_difference2) +
		dot(normal_finite_difference3, normal_finite_difference3)
	) * 0.5;

	return smoothstep(normal_threshold - normal_smoothing, normal_threshold + normal_smoothing, edge_normal);
}
#else
float detect_edges_normal(uv_neighbors uvs, sampler2D norm_tex, vec3 cam_dir_world) {
	vec3 n_u = texture(norm_tex, uvs.up).xyz;
	vec3 n_d = texture(norm_tex, uvs.down).xyz;
	vec3 n_l = texture(norm_tex, uvs.left).xyz;
	vec3 n_r = texture(norm_tex, uvs.right).xyz;
	vec3 n_tl = texture(norm_tex, uvs.top_left).xyz;
	vec3 n_tr = texture(norm_tex, uvs.top_right).xyz;
	vec3 n_bl = texture(norm_tex, uvs.bottom_left).xyz;
	vec3 n_br = texture(norm_tex, uvs.bottom_right).xyz;

	vec3 normal_finite_difference0 = n_tr - n_bl;
	vec3 normal_finite_difference1 = n_tl - n_br;
	vec3 normal_finite_difference2 = n_l - n_r;
	vec3 normal_finite_difference3 = n_u - n_d;

	float edge_normal = sqrt(
		dot(normal_finite_difference0, normal_finite_difference0) +
		dot(normal_finite_difference1, normal_finite_difference1) +
		dot(normal_finite_difference2, normal_finite_difference2) +
		dot(normal_finite_difference3, normal_finite_difference3)
	);

	return smoothstep(normal_threshold - normal_smoothing, normal_threshold + normal_smoothing, edge_normal);
}
#endif // SUPPORT_MOBILE

void vertex() {
	POSITION = vec4(VERTEX, 1.0);

#ifdef SUPPORT_MOBILE
	model_view_matrix = INV_VIEW_MATRIX * mat4(VIEW_MATRIX[0], VIEW_MATRIX[1], VIEW_MATRIX[2], VIEW_MATRIX[3]);
#endif
}

void fragment() {
	float aspect = float(VIEWPORT_SIZE.y) / float(VIEWPORT_SIZE.x);

	uv_neighbors n = get_neighbors(SCREEN_UV, max_thickness, aspect);
	neighbor_depth_samples depth_samples = get_linear_depth_samples(n, depth_texture, INV_PROJECTION_MATRIX);

	float min_d = get_minimum_depth(depth_samples);
	float thickness = clamp(remap(min_d, min_distance, max_distance, max_thickness, min_thickness), min_thickness, max_thickness);
	float fade_a = clamp(remap(min_d, min_distance, max_distance, 1.0, 0.0), 0.0, 1.0);

	n = get_neighbors(SCREEN_UV, thickness, aspect);
	depth_samples = get_linear_depth_samples(n, depth_texture, INV_PROJECTION_MATRIX);

#ifndef SUPPORT_MOBILE
	vec3 pixel_normal = texture(normr_texture, SCREEN_UV).xyz;
#else
	vec3 pixel_normal = reconstruct_world_normal(depth_texture, model_view_matrix, INV_PROJECTION_MATRIX, SCREEN_UV, MODEL_MATRIX, INV_VIEW_MATRIX, VIEWPORT_SIZE.xy);
#endif

	float depth_edges = detect_edges_depth(depth_samples, pixel_normal, VIEW);

#ifndef SUPPORT_MOBILE
	float norm_edges = min(detect_edges_normal(n, normr_texture, CAMERA_DIRECTION_WORLD), 1.0);
#else
	float norm_edges = min(detect_edges_normal_reconstructed(n, depth_texture, model_view_matrix, INV_PROJECTION_MATRIX, SCREEN_UV, MODEL_MATRIX, INV_VIEW_MATRIX, VIEWPORT_SIZE.xy), 1.0);
#endif

	ALBEDO.rgb = outline_color.rgb;
	ALPHA = max(depth_edges, norm_edges) * outline_color.a * fade_a;
}
