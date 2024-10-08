extends Node

var transitionning = false

func get_scene_position(node: Node, direction: Enum.Direction) -> Vector2:
	if direction == Enum.Direction.LEFT:
		return Vector2(-node.size.x, 0)

	if direction == Enum.Direction.TOP:
		return Vector2(0, -node.size.y)

	if direction == Enum.Direction.RIGHT:
		return Vector2(node.size.x, 0)

	if direction == Enum.Direction.BOTTOM:
		return Vector2(0, node.size.y)

	return Vector2(0, 0)

func switch_to_scene_from_position(scene: PackedScene, new_scene_position: Enum.Direction):
	if transitionning:
		return

	var new_scene: Node = scene.instantiate()
	var current_scene = get_tree().current_scene

	get_tree().root.add_child(new_scene)

	var tween: Tween = create_tween().set_parallel(true)

	# change scene position
	tween.tween_property(current_scene, "position", -get_scene_position(current_scene, new_scene_position), 0.5).set_trans(Tween.TRANS_CIRC)
	tween.tween_property(new_scene, "position", Vector2(0, 0), 0.7).set_trans(Tween.TRANS_BACK)

	# change current_scene opacity
	tween.tween_property(current_scene, "modulate:a", 0, 0.6)
	tween.tween_property(new_scene, "modulate:a", 1, 0.4)

	await tween.finished

	transitionning = false
