extends Control

@onready var main_menu = $MainMenu
@onready var option_menu = $OptionMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# move option menu off screen
	var screen_size = get_viewport_rect().size
	option_menu.position.x = screen_size.x


func _on_resized() -> void:
	if option_menu == null:
		return
	var screen_size = get_viewport_rect().size
	option_menu.position.x = screen_size.x


func _on_option_button_toggled() -> void:
	pass