extends Menu

@onready var game = preload("res://scenes/board/game.tscn")
@onready var start_button = $StartButton
@onready var option_button = $OptionButton

func _ready() -> void:
	start_button.grab_focus()
	option_button.connect("pressed", _on_option_button_pressed)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(game)

func _on_option_button_pressed() -> void:
	open_menu.emit('option_menu')
