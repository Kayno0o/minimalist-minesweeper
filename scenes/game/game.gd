extends Control
class_name Game

enum Difficulty {EASY, NORMAL, HARD, CUSTOM}

var has_game_started = false

@onready var board: GameBoard = %Board

func _ready():
	board.start_game(10, 10, 16)
