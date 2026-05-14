extends Area2D

@export var floor_number: int


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_overlapping_bodies(): 
		for body in get_overlapping_bodies():
			body.current_floor = floor_number
