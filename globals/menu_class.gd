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

func get_menu_from_position(menu_position: Enum.MenuPosition) -> Menu:
  if menu_position == Enum.MenuPosition.LEFT:
    return left

  if menu_position == Enum.MenuPosition.TOP:
    return top

  if menu_position == Enum.MenuPosition.RIGHT:
    return right

  if menu_position == Enum.MenuPosition.BOTTOM:
    return bottom

  return null
