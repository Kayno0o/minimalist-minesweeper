extends Control

@export var current_menu_index: int
@export var menus: Array[Menu] = []

func _ready() -> void:
	for menu in menus:
		menu.connect("open_menu", _on_open_menu)

	_offset_menus()

func _on_resized() -> void:
	_offset_menus()

func _offset_menus() -> void:
	if menus[current_menu_index] == null:
		return

	var screen_size = get_viewport_rect().size
	for menu_index in menus.size():
		var menu = menus[menu_index]

		menu.visible = true
		menu.size = screen_size

		if menu.menu_name == menus[current_menu_index].menu_name:
			menu.position.x = 0
			continue

		menu.position.x = get_menu_position(menu, menu_index)

func _on_open_menu(menu_name_to_move: String) -> void:
	var new_menu_index: int = -1

	for menu_index in menus.size():
		if menus[menu_index].menu_name == menu_name_to_move:
			new_menu_index = menu_index

	if new_menu_index == -1:
		return

	var new_menu = menus[new_menu_index]
	var current_menu = menus[current_menu_index]

	var tween: Tween = create_tween()
	tween.tween_property(current_menu, "position", Vector2(-get_menu_position(current_menu, new_menu_index), 0), 0.5).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(new_menu, "position", Vector2(0, 0), 0.5).set_trans(Tween.TRANS_CIRC)
	await tween.finished
	current_menu_index = new_menu_index
	_offset_menus()

func get_menu_position(menu: Menu, menu_index: int) -> int:
	return -menu.size.x if menu_index < current_menu_index else menu.size.x