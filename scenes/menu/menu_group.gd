extends Control

@export var menus: Array[Menu] = []
@export var current_menu: Menu

var transitionning: bool = false

func _ready() -> void:
	for menu in menus:
		for button in menu.buttons:
			button.connect("go_to_menu", _on_go_to_menu)

	init_menus()

func init_menus() -> void:
	if current_menu == null:
		return

	for menu_index in menus.size():
		var menu = menus[menu_index]

		if menu.menu_name == current_menu.menu_name:
			menu.set_process(true)
			menu.visible = true
			continue

		menu.set_process(false)
		menu.visible = false

func get_menu_position(menu: Menu, menu_position: Enum.Direction) -> Vector2:
	if menu_position == Enum.Direction.LEFT:
		return Vector2(-menu.size.x, 0)

	if menu_position == Enum.Direction.TOP:
		return Vector2(0, -menu.size.y)

	if menu_position == Enum.Direction.RIGHT:
		return Vector2(menu.size.x, 0)

	if menu_position == Enum.Direction.BOTTOM:
		return Vector2(0, menu.size.y)

	return Vector2(0, 0)

func _on_go_to_menu(new_menu_position: Enum.Direction) -> void:
	if transitionning:
		return

	var new_menu: Menu = current_menu.get_menu_from_position(new_menu_position)

	if new_menu == null:
		return

	transitionning = true

	new_menu.visible = true
	new_menu.set_process(true)
	new_menu.position = get_menu_position(new_menu, new_menu_position)

	var tween: Tween = create_tween().set_parallel(true)

	# change menu position
	tween.tween_property(current_menu, "position", -get_menu_position(current_menu, new_menu_position), 0.5).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(new_menu, "position", Vector2(0, 0), 0.7).set_trans(Tween.TRANS_BACK)

	# change current_menu opacity
	tween.tween_property(current_menu, "modulate:a", 0, 0.6)
	tween.tween_property(new_menu, "modulate:a", 1, 0.4)

	await tween.finished

	current_menu.visible = false
	current_menu.set_process(false)
	current_menu = new_menu

	if new_menu.main_button != null:
		new_menu.main_button.grab_focus()
	elif new_menu.buttons[0] != null:
		new_menu.buttons[0].grab_focus()
	
	transitionning = false
