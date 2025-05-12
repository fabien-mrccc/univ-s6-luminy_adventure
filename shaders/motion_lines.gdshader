shader_type canvas_item;

uniform int sprint_active = 0;
uniform float speed_scale = 16.0;
uniform float clip_position = 0.2;

float random (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}

void fragment() {
	if (sprint_active == 1) {
		COLOR.a = 0.0;
	
		vec2 pos = UV - vec2(0.5);
		float theta = round(64.0 * atan(pos.y, pos.x));
		float dist = sqrt(pow(pos.x, 2) + pow(pos.y, 2));
		
		float dist_value = round(dist * 4.0 + TIME * - speed_scale + 8.0 * random(vec2(theta)));
		if (dist > clip_position + random(vec2(theta)) * 0.3 && random(vec2(theta, dist_value)) < 0.02) {
			COLOR.a = 1.0;
		}
	}
}