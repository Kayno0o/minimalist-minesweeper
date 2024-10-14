extends Node

var transitionning = false

var root: Control
var current_scene: Node

@onready var loading_screen_packed: PackedScene = preload("res://scenes/menu/loading_screen/loading_screen.tscn")

func init(_root: Control):
	root = _root
	current_scene = root.get_child(0)

func get_scene_position(node, direction: Enum.Direction) -> Vector2:
	return Vector2(Utils.get_vector(
		direction == Enum.Direction.TOP,
		direction == Enum.Direction.RIGHT,
		direction == Enum.Direction.BOTTOM,
		direction == Enum.Direction.LEFT,
	)) * node.size

func switch_to_scene_from_position(scene: String, new_scene_position: Enum.Direction, with_loading: bool = true):
	call_deferred("_switch_to_scene_from_position", scene, new_scene_position, with_loading)

func _switch_to_scene_from_position(scene: String, direction: Enum.Direction, with_loading: bool = true):
	if transitionning:
		return

	transitionning = true

	if not with_loading:
		var previous_scene = current_scene
		await load_scene_async(scene)
		await transition_to_node(previous_scene, current_scene, direction)

		transitionning = false

		return

	# Show loading screen
	var loading_screen: LoadingScreen = loading_screen_packed.instantiate()
	root.add_child(loading_screen)
	var progress_bar = loading_screen.loading_bar
	await transition_to_node(current_scene, loading_screen, direction)

	root.remove_child(current_scene)

	# Load the new scene asynchronously
	await load_scene_async(scene, progress_bar)
	current_scene.position = get_scene_position(current_scene, direction)
	await get_tree().create_timer(0.1).timeout

	await transition_to_node(loading_screen, current_scene, direction)

	transitionning = false


# asynchronously loads the scene and updates the loading bar
func load_scene_async(scene_path: String, progress_bar: ProgressBar = null):
	# request the scene to be loaded in a separate thread
	ResourceLoader.load_threaded_request(scene_path)

	# array to store the progress percentage
	var progress = []
	if progress_bar != null:
		progress_bar.max_value = 1
		progress_bar.value = 0

	while ResourceLoader.load_threaded_get_status(scene_path, progress) != ResourceLoader.THREAD_LOAD_LOADED:
		if progress_bar != null:
			progress_bar.value = progress[0]
		await get_tree().process_frame

	# finish loading bar
	if progress_bar != null:
		ResourceLoader.load_threaded_get_status(scene_path, progress)
		progress_bar.value = progress[0]

	# once the scene is loaded, retrieve it
	var new_scene = ResourceLoader.load_threaded_get(scene_path)
	if new_scene:
		var instantiated_scene = new_scene.instantiate()
		root.add_child(instantiated_scene)
		current_scene = instantiated_scene
	else:
		push_error("Failed to load scene: %s" % scene_path)

func transition_to_loading(direction: Enum.Direction) -> ProgressBar:
	var loading_screen: LoadingScreen = loading_screen_packed.instantiate()
	root.add_child(loading_screen)
	var progress_bar = loading_screen.loading_bar

	await transition_to_node(current_scene, loading_screen, direction)

	return progress_bar


func transition_to_node(from: Node, to: Node, direction: Enum.Direction):
	if to != null:
		to.set_process(true)
		to.visible = true
		to.position = get_scene_position(to, direction)

	var tween: Tween = create_tween().set_parallel(true)

	# change scene position
	tween.tween_property(from, "position", -get_scene_position(from, direction), 0.5).set_trans(Tween.TRANS_CIRC)
	if to != null:
		tween.tween_property(to, "position", Vector2(0, 0), 0.7).set_trans(Tween.TRANS_BACK)

	# change from opacity
	tween.tween_property(from, "modulate:a", 0, 0.6)
	if to != null:
		tween.tween_property(to, "modulate:a", 1, 0.4)

	await tween.finished

	if from != null:
		from.set_process(false)
		from.visible = false

		if from is Menu and from.main_button != null:
			from.main_button.grab_focus()
