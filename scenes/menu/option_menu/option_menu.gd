extends Menu

@onready var main_menu_button: Button = $MainMenuButton

func _ready():
	main_menu_button.connect("pressed", _on_open_main_menu)

func _on_open_main_menu():
	open_menu.emit("main_menu")
