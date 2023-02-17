shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D noise;
uniform float dissolution_level: hint_range(0, 1) = 0.0;
uniform float edge_width: hint_range(0, 1) = 0.0;
uniform vec4 edge_color1: hint_color = vec4(1, 1, 1, 1);
uniform vec4 edge_color2: hint_color = vec4(1, 1, 1, 1);
uniform vec4 replacement_color: hint_color = vec4(1, 1, 1, 0);

void fragment() {
    float cutout = texture(noise, SCREEN_UV.xy).r;
    vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV.xy);

    if (cutout < dissolution_level) {
       COLOR = replacement_color;
    }
    else if (cutout < color.a && cutout < dissolution_level + edge_width) {
       COLOR = mix(edge_color1, edge_color2, (cutout - dissolution_level) / edge_width);
    }
    else {
      COLOR = color;
    }
}