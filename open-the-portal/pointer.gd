@tool
extends Node2D


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if get_parent().door:
			$RayCast2D.visible = true
			$RayCast2D.target_position = to_local(get_parent().door.position)
		else:
			$RayCast2D.visible = false
