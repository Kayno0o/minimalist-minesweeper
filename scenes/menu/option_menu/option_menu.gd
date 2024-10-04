extends Menu

func _on_animated_bg_button_toggled(toggled_on: bool) -> void:
	RenderingServer.global_shader_parameter_set("animated_background", toggled_on)
