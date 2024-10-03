shader_type canvas_item;

uniform lowp vec2 region_size = vec2(16.0, 16.0); // Size of the region to tile
uniform lowp vec2 region_position = vec2(0.0, 0.0);

global uniform bool animated_background;

void fragment() {
  lowp vec2 texture_size = vec2(textureSize(TEXTURE, 0));

  if (!animated_background) {
    COLOR = texture(TEXTURE, (mod(UV * texture_size, region_size) + region_position) / texture_size);
  } else {
    lowp vec2 uv_offset = vec2(TIME * 8.0);

    lowp vec2 uv = mod(UV * texture_size + uv_offset, region_size) / texture_size;
    COLOR = texture(TEXTURE, uv + region_position / texture_size);
  }
}
