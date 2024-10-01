extends Button
class_name Cell

var cell_size: Vector2 = Vector2(16, 16)

func _ready() -> void:
	# size = cell_size
	# print(cell_size)
	self.pressed.connect(_on_pressed)

func _on_pressed() -> void:
	print("pressed")