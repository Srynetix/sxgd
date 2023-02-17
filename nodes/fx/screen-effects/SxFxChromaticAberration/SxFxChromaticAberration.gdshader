// Adapted from https://gist.github.com/uheartbeast/312a7ea761b8712c448b31c30c0d8f1f
shader_type canvas_item;

uniform bool apply = false;
uniform float amount = 1.0;

void fragment() {
    vec4 texture_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec4 color = texture_color;

    if (apply == true) {
        float adjusted_amount = amount * texture(SCREEN_TEXTURE, SCREEN_UV).r / 100.0;
        color.r = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x + adjusted_amount, SCREEN_UV.y)).r;
        color.g = texture(SCREEN_TEXTURE, SCREEN_UV).g;
        color.b = texture(SCREEN_TEXTURE, vec2(SCREEN_UV.x - adjusted_amount, SCREEN_UV.y)).b;
    }
    COLOR = color;
}