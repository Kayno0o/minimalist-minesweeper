extends Button
class_name MenuBaseButton

signal open_menu(menu_name: String)

@export var menu_name: String

func _ready() -> void:
  connect("pressed", _on_pressed)

func _on_pressed() -> void:
  open_menu.emit(menu_name)
