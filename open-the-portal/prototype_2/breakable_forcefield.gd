extends Area2D
@export var is_strong_wall: bool

signal wall_is_broken


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_overlapping_bodies():
		if is_strong_wall:
			if get_overlapping_bodies()[0].is_in_group("Power Orbs"):
				wall_is_broken.emit()
		else:
			wall_is_broken.emit()
