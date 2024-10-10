extends Node

func get_vector(top: bool, right: bool, bottom: bool, left: bool) -> Vector2i:
  var result = Vector2i(0, 0)
  
  if top:
    result += Vector2i(0, -1)
  
  if right:
    result += Vector2i(1, 0)
  
  if bottom:
    result += Vector2i(0, 1)
  
  if left:
    result += Vector2i(-1, 0)

  return result