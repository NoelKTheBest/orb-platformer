extends Area2D

signal wall_is_broken


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_overlapping_bodies():
		wall_is_broken.emit()
