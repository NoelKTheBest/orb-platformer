extends Area2D

@export var floor_number: int
## A list of ID's to use to identify which enemies should be
## spawned in a room on death at least for this one wave
@export var on_death_spawn_IDs = []
# ID List
# 0 - Mercenary
# 1 - Assassin
# 2 - Gunner


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if has_overlapping_bodies(): 
		for body in get_overlapping_bodies():
			body.current_floor = floor_number
