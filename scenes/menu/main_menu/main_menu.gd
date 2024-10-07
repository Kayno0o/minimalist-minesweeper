extends Menu

@onready var game = preload("res://scenes/board/game.tscn")

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game)
