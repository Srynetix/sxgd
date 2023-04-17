shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float strength : hint_range(0, 5, 0.001) = 0;

void fragment() {
	if (strength > 0.0) {
	    vec3 col = texture(SCREEN_TEXTURE, SCREEN_UV).xyz * 0.16;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, SCREEN_PIXEL_SIZE.y)).xyz * 0.15;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, -SCREEN_PIXEL_SIZE.y)).xyz * 0.15;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, strength * 2.0 * SCREEN_PIXEL_SIZE.y)).xyz * 0.12;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, strength * 2.0 * -SCREEN_PIXEL_SIZE.y)).xyz * 0.12;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, strength * 3.0 * SCREEN_PIXEL_SIZE.y)).xyz * 0.09;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, strength * 3.0 * -SCREEN_PIXEL_SIZE.y)).xyz * 0.09;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, strength * 4.0 * SCREEN_PIXEL_SIZE.y)).xyz * 0.05;
	    col += texture(SCREEN_TEXTURE, SCREEN_UV + vec2(0.0, strength * 4.0 * -SCREEN_PIXEL_SIZE.y)).xyz * 0.05;
	    COLOR.xyz = col;
	} else {
    	COLOR.xyz = texture(SCREEN_TEXTURE, SCREEN_UV).xyz;
	}
}