shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 direction;
uniform float strength : hint_range(0, 5, 0.01) = 0;

void fragment() {
    vec4 sum = vec4(0.0);
    float hstep = direction.x * SCREEN_PIXEL_SIZE.x;
    float vstep = direction.y * SCREEN_PIXEL_SIZE.y;
    float blur = strength;
    vec2 tc = SCREEN_UV;

    if (strength > 0.0) {
        sum += texture(SCREEN_TEXTURE, vec2(tc.x - 4.0*blur*hstep, tc.y - 4.0*blur*vstep)) * 0.0162162162;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x - 3.0*blur*hstep, tc.y - 3.0*blur*vstep)) * 0.0540540541;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x - 2.0*blur*hstep, tc.y - 2.0*blur*vstep)) * 0.1216216216;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x - 1.0*blur*hstep, tc.y - 1.0*blur*vstep)) * 0.1945945946;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x, tc.y)) * 0.2270270270;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x + 1.0*blur*hstep, tc.y + 1.0*blur*vstep)) * 0.1945945946;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x + 2.0*blur*hstep, tc.y + 2.0*blur*vstep)) * 0.1216216216;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x + 3.0*blur*hstep, tc.y + 3.0*blur*vstep)) * 0.0540540541;
        sum += texture(SCREEN_TEXTURE, vec2(tc.x + 4.0*blur*hstep, tc.y + 4.0*blur*vstep)) * 0.0162162162;

        COLOR.rgb = sum.rgb;
    } else {
        COLOR.rgb = texture(SCREEN_TEXTURE, SCREEN_UV).xyz;
    }
}