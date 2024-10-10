extends Control
class_name Game

@export var grid_width: int = 16
@export var grid_height: int = 16
@export var bomb_count: int = 24

@onready var board: Control = %Board
@onready var fg: TileMapLayer = %Foreground
@onready var bg: TileMapLayer = %Background

var bombs: Array[Vector2i] = []

const PRESSED = 0
const UNPRESSED = 1

const NEIGHBOR_DIR: Array[Vector2i] = [Vector2i(1, -1), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1), Vector2i(-1, 1), Vector2i(-1, 0), Vector2i(-1, -1), Vector2i(0, -1)]

func _ready():
	start_game()

func start_game():
	bg.position = Vector2(0, 0)
	bg.clear()

	fg.position = Vector2(0, 0)
	fg.clear()
	
	bombs.clear()

	# generate game board
	var cells: Array[Vector2i] = []
	for y in range(grid_height):
		for x in range(grid_width):
			cells.append(Vector2i(x, y))
	bg.set_cells_terrain_connect(cells, 0, UNPRESSED, true)

	# add bombs
	for i in range(bomb_count):
		var rid = randi_range(0, cells.size() - 1)
		var cell = cells[rid]

		bombs.append(cell)
		cells.remove_at(rid)

	cells.clear()

	# get the board-container ratio to make the board fit
	var board_size: Vector2 = board.get_rect().size
	var container_size: Vector2 = Vector2(bg.get_used_rect().size) * Vector2(bg.tile_set.tile_size)
	var ratio = min(board_size.x / container_size.x, board_size.y / container_size.y)

	bg.scale = Vector2(ratio, ratio)
	fg.scale = Vector2(ratio, ratio)

func _input(event: InputEvent):
	if not event is InputEventMouseButton or !event.pressed:
		return

	var local_position = bg.to_local(event.global_position)
	var cell: Vector2i = bg.local_to_map(local_position)
	var bg_data: TileData = bg.get_cell_tile_data(cell)
	var fg_data: TileData = fg.get_cell_tile_data(cell)

	if event.button_index == MOUSE_BUTTON_LEFT:
		var is_flag = fg_data.get_custom_data("is_flag") if fg_data != null else false
		if is_flag:
			return

		var is_bomb: bool = get_is_bomb(cell)

		if is_bomb:
			handle_lose()
		else:
			explore(cell)
			check_and_handle_win()

		return
	
	if event.button_index == MOUSE_BUTTON_RIGHT:
		if bg_data == null:
			return

		if bg_data.get_custom_data("is_pressed"):
			return

		if fg_data != null and fg_data.get_custom_data("is_flag"):
			fg.set_cell(cell)
			check_and_handle_win()
		elif fg_data == null:
			fg.set_cell(cell, 0, Vector2i(0, 1))
			check_and_handle_win()

func get_is_bomb(cell: Vector2i) -> bool:
	for bomb in bombs:
		if bomb.x == cell.x and bomb.y == cell.y:
			return true
	return false

func explore(cell_to_explore: Vector2i):
	var cells_queue: Array[Vector2i] = [cell_to_explore]

	while cells_queue.size():
		var cell = cells_queue[0]
		cells_queue.remove_at(0)

		var cell_data = bg.get_cell_tile_data(cell)
		if cell_data == null:
			continue
		if cell_data.get_custom_data("is_pressed"):
			continue

		bg.set_cells_terrain_connect([cell], 0, PRESSED, true)

		var surrounding_cells = get_surrounding_cells(cell)
		var neighbor_bombs = has_bomb_neighbour(surrounding_cells)
		if neighbor_bombs:
			fg.set_cell(cell, 0, Vector2i(neighbor_bombs - 1, 0))
			continue

		cells_queue.append_array(surrounding_cells)

func get_surrounding_cells(cell: Vector2i) -> Array[Vector2i]:
	return NEIGHBOR_DIR.reduce(
		func(acc: Array[Vector2i], dir: Vector2i):
			var neighbor: Vector2i = cell + dir
			if bg.get_cell_source_id(neighbor) != null:
				acc.append(neighbor)
			return acc,
		[] as Array[Vector2i]
	)

func has_bomb_neighbour(surrounding_cells: Array[Vector2i]) -> int:
	var number: int = 0
	for neighbour in surrounding_cells:
		if get_is_bomb(neighbour):
			number += 1
	return number

func handle_lose():
	print("lose")

func check_and_handle_win():
	var is_win = get_is_win()
	if is_win:
		print("win")

func get_is_win() -> bool:
	for y in range(grid_height):
		for x in range(grid_width):
			var cell = Vector2i(x, y)

			var bg_data = bg.get_cell_tile_data(cell)
			var fg_data = fg.get_cell_tile_data(cell)

			if bg_data == null:
				return false

			var is_bomb = get_is_bomb(cell)
			var is_pressed = bg_data.get_custom_data("is_pressed")

			if is_bomb:
				if fg_data == null:
					continue

				var is_flag = fg_data.get_custom_data("is_flag") if fg_data != null else false
				if not is_flag:
					return false
				
				continue

			if not is_pressed:
				return false

	return true
