shader_type canvas_item;

uniform float offset_speed = 0.00005;
uniform vec2 region_size = vec2(16.0, 16.0); // Size of the region to tile
uniform vec2 total_texture_size = vec2(128.0, 128.0); // Total size of the texture
uniform vec2 region_position = vec2(32.0, 0.0);

void fragment() {
    // Convert UV to pixel space relative to the total texture size
    vec2 uv = UV * total_texture_size;

    // Restrict to the region you want to display (first 16x16 pixels in this case)
    uv = mod(uv + TIME * offset_speed * total_texture_size.x, region_size) + region_position;

    // Normalize UV back to [0, 1] range relative to the total texture size
    uv /= total_texture_size;

    // Sample the texture
    COLOR = texture(TEXTURE, uv);
}
