shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float angle_degrees;
uniform int samples = 10;
uniform float strength : hint_range(0, 0.02, 0.0001);

vec4 motionBlur(sampler2D sampler, vec2 uv, vec2 dir) {
  vec4 l = vec4(0);
  float delta = 1.0 / float(samples);
  for (float i = -1.0; i <= 1.0; i += delta) {
    l += texture(sampler, uv - vec2(dir.x * i, dir.y * i)).rgba;
  }
  
  return vec4(l * delta * 0.5);
}

void fragment() {
  float rad = radians(angle_degrees);
  vec2 blur_vector = vec2(cos(rad), sin(rad)) * strength;
  COLOR = motionBlur(SCREEN_TEXTURE, SCREEN_UV, blur_vector);
}