extends Control

@onready var grid: GridContainer = $Grid
@onready var cell_scene: PackedScene = preload("res://scenes/board/cell/cell.tscn")

@export var grid_width: int = 10
@export var grid_height: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid.columns = grid_width
	print(grid.get_global_rect())
	for i in range(grid_width):
		for j in range(grid_height):
			var cell: Cell = cell_scene.instantiate()
			cell.cell_size = (grid.scale * grid.size) / Vector2(grid_width, grid_height)
			grid.add_child(cell)
