extends Control

@onready var grid: TileMapLayer = $Grid

@export var grid_width: int = 10
@export var grid_height: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(grid.tile_set.tile_size)
