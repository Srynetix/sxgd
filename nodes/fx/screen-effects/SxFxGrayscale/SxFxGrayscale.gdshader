shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float ratio : hint_range(0, 1, 0.001) = 0;

void fragment() {
  vec2 uv = SCREEN_UV;
  vec4 screen_color = texture(SCREEN_TEXTURE, uv);
  float grayscale_component = dot(screen_color.rgb, vec3(0.3, 0.59, 0.11));
  COLOR = vec4(mix(screen_color.rgb, vec3(grayscale_component), ratio), screen_color.a);
}