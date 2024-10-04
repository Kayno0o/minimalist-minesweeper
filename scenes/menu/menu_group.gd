extends Control

@export var current_menu_index: int
@export var menus: Array[Menu] = []

var transitionning: bool = false

func _ready() -> void:
	for menu in menus:
		for button in menu.buttons:
			button.connect("open_menu", _on_open_menu)

	init_menus()

func init_menus() -> void:
	if menus[current_menu_index] == null:
		return

	for menu_index in menus.size():
		var menu = menus[menu_index]

		if menu.menu_name == menus[current_menu_index].menu_name:
			menu.visible = true
			menu.set_process(true)

			continue

		menu.visible = false
		menu.set_process(false)

func get_menu_position(menu: Menu, menu_index: int) -> float:
	if menu_index > current_menu_index:
		return menu.size.x

	return -menu.size.x

func _on_open_menu(new_menu_name: String) -> void:
	if transitionning:
		return

	var new_menu_index: int = -1

	for menu_index in menus.size():
		if menus[menu_index].menu_name == new_menu_name:
			new_menu_index = menu_index

	if new_menu_index == -1:
		return

	transitionning = true

	var current_menu = menus[current_menu_index]

	var new_menu = menus[new_menu_index]
	new_menu.visible = true
	new_menu.set_process(true)
	new_menu.position.x = get_menu_position(new_menu, new_menu_index)

	var tween: Tween = create_tween().set_parallel(true)

	# change menu position
	tween.tween_property(current_menu, "position:x", -get_menu_position(current_menu, new_menu_index), 0.5).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(new_menu, "position:x", 0, 0.7).set_trans(Tween.TRANS_BACK)

	# change current_menu opacity
	tween.tween_property(current_menu, "modulate:a", 0, 0.4)
	tween.tween_property(new_menu, "modulate:a", 1, 0.4)

	await tween.finished

	current_menu.visible = false
	current_menu.set_process(false)
	current_menu_index = new_menu_index

	if new_menu.focus_button != null:
		new_menu.focus_button.grab_focus()
	elif new_menu.buttons[0] != null:
		new_menu.buttons[0].grab_focus()
	
	transitionning = false
