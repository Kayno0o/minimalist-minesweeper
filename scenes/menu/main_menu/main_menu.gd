extends Menu

@onready var game = preload("res://scenes/board/game.tscn")
@onready var start_button = $StartButton
@onready var option_button = $OptionButton

func _ready() -> void:
	start_button.grab_focus()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game)
