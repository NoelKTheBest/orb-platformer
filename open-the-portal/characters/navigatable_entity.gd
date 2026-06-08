@abstract extends ControlledEntity
## This class is meant to provide functions and some basic implementation to 
## allow the entity to choose a position to go towards

## Check this when you want the enemy to simply patrol an area. Overrides [b]monitor_player_position[/b]
@export var patrol_area = true

#var target_position: Vector2
var monitor_player_position = false
var player_position = Vector2.ZERO
var camera_position := Vector2.ZERO
var sound_source_position := Vector2.ZERO
var heat_sensor_position := Vector2.ZERO
var nearest_door_position := Vector2.ZERO
var current_floor : int
var using_door: bool = false
var destination_floor: int
var listen_for_player_coords = false


#func normalize_target_position(): return target_position.normalized()


## Function to implement to set the target position of the entity based on position relative to player
func get_target_position() -> Vector2:
	var target_position: Vector2
	
	if monitor_player_position: # and number_of_enemies < min_req_for_helping:
		if nearest_door_position != Vector2.ZERO:
			if !using_door: using_door = true
			target_position = (nearest_door_position - position).normalized()
		else:
			if using_door: using_door = false
			target_position = (player_position - position).normalized()
	
	return target_position
