extends Control

@onready var game = preload("res://scenes/board/game.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game)


func _on_check_button_toggled(toggled_on: bool) -> void:
	RenderingServer.global_shader_parameter_set("animated_background", toggled_on)
