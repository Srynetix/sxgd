shader_type canvas_item;
render_mode blend_mul;

uniform float size = 10.0;
uniform float ratio : hint_range(0, 1, 0.001) = 0.25;

void fragment() {
  vec2 uv = SCREEN_UV;
  uv *= 1.0 - uv.yx;
  
  float vig = uv.x * uv.y * size;
  vig = pow(vig, ratio);
  COLOR = vec4(vig);
}