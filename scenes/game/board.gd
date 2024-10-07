extends Control

@export var grid_width: int = 10
@export var grid_height: int = 10
@export var bomb_count: int = 5

@onready var fg: TileMapLayer = $Foreground
@onready var bg: TileMapLayer = $Background

const PRESSED = 0
const UNPRESSED = 1

func _ready() -> void:
	bg.position = Vector2(0, 0)
	bg.clear()

	# generate game board
	var cells: Array[Vector2i] = []
	for y in range(grid_height):
		for x in range(grid_height):
			cells.append(Vector2i(x, y))
	bg.set_cells_terrain_connect(cells, 0, UNPRESSED, true)

	for cell in cells:
		var tile_data = bg.get_cell_tile_data(cell)
		if tile_data == null:
			push_error("could not get tile data at coords x:", cell.x, "y:", cell.y)
			continue

		tile_data.set_custom_data("is_bomb", false)


	for i in range(bomb_count):
		var rid = randi_range(0, cells.size() - 1)
		var cell = cells[rid]

		var tile_data = bg.get_cell_tile_data(cell)
		if tile_data == null:
			push_error("could not get tile data at coords x:", cell.x, "y:", cell.y)
			continue

		tile_data.set_custom_data("is_bomb", true)
		cells.remove_at(rid)
	
	cells.clear()

	# get the board-container ratio to make the board fit
	var board_size: Vector2 = get_rect().size
	var container_size: Vector2 = Vector2(bg.get_used_rect().size) * Vector2(bg.tile_set.tile_size)
	var ratio = min(board_size.x / container_size.x, board_size.y / container_size.y)

	scale = Vector2(ratio, ratio)

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton or !event.pressed or event.button_index != MOUSE_BUTTON_LEFT:
		return

	var local_position = bg.to_local(event.global_position)

	var cell: Vector2i = bg.local_to_map(local_position)
	var tile_data: TileData = bg.get_cell_tile_data(cell)
	if tile_data == null:
		push_error("could not get tile data at coords x:", cell.x, "y:", cell.y)
		return

	var is_bomb: bool = tile_data.get_custom_data("is_bomb")
	print(is_bomb, ' - x:', cell.x, ', y:', cell.y)
	if not is_bomb:
		bg.set_cells_terrain_connect([cell], 0, PRESSED, true)
