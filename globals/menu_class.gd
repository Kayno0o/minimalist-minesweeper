extends Control
class_name Menu

@export var menu_name: String
@export var buttons: Array[MenuBaseButton] = []
@export var main_button: Button

@export_category("Positionning")
@export var left: Menu
@export var top: Menu
@export var right: Menu
@export var bottom: Menu

func get_menu_from_position(menu_position: Enum.Direction) -> Menu:
  if menu_position == Enum.Direction.LEFT:
    return left

  if menu_position == Enum.Direction.TOP:
    return top

  if menu_position == Enum.Direction.RIGHT:
    return right

  if menu_position == Enum.Direction.BOTTOM:
    return bottom

  return null
