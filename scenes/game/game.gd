extends Menu
class_name Game

enum Difficulty {EASY, NORMAL, HARD, CUSTOM}

var current_difficulty: Difficulty

@onready var board: GameBoard = %Board

@onready var board_wrapper = $BoardWrapper
@onready var difficulty_select = $DifficultySelect
@onready var end_screen = $EndScreen

func _ready():
	board.win.connect(_on_win)
	board.lose.connect(_on_lose)

	difficulty_select.visible = true
	difficulty_select.position = Vector2(0, 0)

func _on_win():
	print("You win!")

func _on_lose():
	await MenuSwitcher.transition_to_node(board_wrapper, end_screen, Enum.Direction.TOP)

func _on_start_difficulty(difficulty: Difficulty) -> void:
	start_game(difficulty)

	await MenuSwitcher.transition_to_node(difficulty_select, board_wrapper, Enum.Direction.TOP)

func _on_restart_game() -> void:
	start_game(current_difficulty)

	await MenuSwitcher.transition_to_node(end_screen, board_wrapper, Enum.Direction.BOTTOM)

func start_game(difficulty: Difficulty) -> void:
	current_difficulty = difficulty

	match difficulty:
		Difficulty.EASY:
			board.start_game(10, 10, int(((10*10)/100.0) * 11))
		Difficulty.NORMAL:
			board.start_game(16, 16, int(((16*16)/100.0) * 14))
		Difficulty.HARD:
			board.start_game(24, 24, int(((24*24)/100.0) * 18))
		Difficulty.CUSTOM:
			# show custom difficulty screen
			pass