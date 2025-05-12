shader_type canvas_item;

uniform vec4 crosshair_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform vec4 border_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

uniform float radius : hint_range(0.0, 1, 0.001) = 0.05;

uniform float border_thickness : hint_range(0.001, 1, 0.001) = 0.01;

uniform float opacity : hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
    vec2 uv = UV - vec2(0.5);
    float dist = length(uv);

    if (dist < radius + border_thickness) {
        if (dist < radius) {
            COLOR = vec4(crosshair_color.rgb, crosshair_color.a * opacity);
        } else {
            COLOR = vec4(border_color.rgb, border_color.a * opacity);
        }
    } else {
        discard;
    }
}
