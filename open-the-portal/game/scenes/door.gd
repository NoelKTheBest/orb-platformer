extends Polygon2D

signal player_can_use_door



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Area2D.has_overlapping_bodies():
		player_can_use_door.emit()
