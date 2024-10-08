extends Button
class_name MenuBaseButton

signal go_to_menu(menu_position: Enum.Direction)

@export var menu_position: Enum.Direction

func _ready() -> void:
  connect("pressed", _on_pressed)

func _on_pressed() -> void:
  go_to_menu.emit(menu_position)
