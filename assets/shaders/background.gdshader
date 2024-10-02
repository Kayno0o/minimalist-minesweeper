shader_type canvas_item;

uniform vec2 region_size = vec2(16.0, 16.0); // Size of the region to tile
uniform vec2 region_position = vec2(32.0, 0.0);
global uniform bool animated_background;

void fragment() {
	vec2 texture_size = vec2(textureSize(TEXTURE, 0));

	if (!animated_background) {
    	COLOR = texture(TEXTURE, (mod(UV * texture_size, region_size) + region_position) / texture_size);
	} else {
	    // Get pixel coordinates in texture space
	    vec2 uv = mod((UV + TIME/8.0) * texture_size, region_size);

	    // Sample the texture with the new UV coordinates
	    COLOR = texture(TEXTURE, (uv + region_position) / texture_size);
	}
}
