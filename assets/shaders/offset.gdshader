shader_type canvas_item;

uniform float offset_speed = 0.05;

void fragment() {
    // offset based on time
    COLOR = texture(TEXTURE, UV + TIME * offset_speed);
}
