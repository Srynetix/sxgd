shader_type canvas_item;
render_mode unshaded;

uniform sampler2D noise;
uniform float dissolution_level: hint_range(0, 1) = 0.0;
uniform float edge_width: hint_range(0, 1) = 0.0;
uniform vec4 edge_color1: source_color = vec4(1, 1, 1, 1);
uniform vec4 edge_color2: source_color = vec4(1, 1, 1, 1);

void fragment() {
    float cutout = texture(noise, UV.xy).r;
    vec4 color = texture(TEXTURE, UV.xy);
    
    if (cutout < dissolution_level) {
       discard;
    }
    
    if (cutout < color.a && cutout < dissolution_level + edge_width) {
       color = mix(edge_color1, edge_color2, (cutout - dissolution_level) / edge_width);
    }
}