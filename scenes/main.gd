extends Control

@onready var root: Control = %Root

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MenuSwitcher.init(root)
