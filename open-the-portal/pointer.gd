@tool
extends Node


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$RayCast2D.target_position = get_parent().door.position
		$RayCast2D.position = get_parent().position
