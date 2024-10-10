extends Button
class_name SceneButton

@export var direction: Enum.Direction
@export var transition_with_loading_screen: bool = true
@export_file("*.tscn") var load_scene: String

func _ready() -> void:
  connect("pressed", _on_pressed)

func _on_pressed() -> void:
  MenuSwitcher.switch_to_scene_from_position(load_scene, direction, transition_with_loading_screen)
