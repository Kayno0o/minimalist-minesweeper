extends Button

@export var difficulty: Game.Difficulty

signal start_difficulty(difficulty: Game.Difficulty)

func _ready():
  pressed.connect(_on_pressed)

func _on_pressed():
  start_difficulty.emit(difficulty)
