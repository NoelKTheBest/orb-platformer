extends Area2D

@export var floor_number: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_overlapping_areas(): 
		for body in get_overlapping_bodies():
			if body.is_in_group("Enemy"):
				body.current_floor = floor_number
