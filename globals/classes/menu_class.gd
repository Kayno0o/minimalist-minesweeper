extends Control
class_name Menu

@export var main_button: Button

func _ready():
  if not main_button == null:
    main_button.grab_focus()
