extends TileMapLayer

@export var grid_width: int = 10
@export var grid_height: int = 10

@onready var board: Control = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Calculate the size of each tile to fit the grid into the board size
	var board_size: Vector2 = board.get_rect().size
	var grid_size: Vector2 = Vector2(get_used_rect().size) * Vector2(tile_set.tile_size) * scale
	var ratio = min(board_size.x / grid_size.x, board_size.y / grid_size.y)

	scale = Vector2(ratio, ratio)
