@tool
extends Area2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		if has_overlapping_areas():
			# Might not be working bc floor_area.gd is not a @tool script
			#get_parent().floor_number = get_overlapping_bodies()[0].floor_number
			pass
