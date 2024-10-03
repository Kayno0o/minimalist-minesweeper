extends CheckBox

func _on_toggled(toggled_on:bool) -> void:
	RenderingServer.global_shader_parameter_set("animated_background", toggled_on)
