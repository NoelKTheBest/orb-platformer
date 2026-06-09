@abstract extends ControlledEntity
## This class is meant to provide functions and some basic implementation to 
## allow the entity to choose a position to go towards

## Determines if entity should walk from position to position in an area and
## waiting to see if the player enters their FOV. Overrides [b]monitor_player_position[/b]
@export var patrol_area = true
## Determines if entity should stay in position as part of a squadron. Overrides [b]patrol_area[/b]
@export var on_gaurd := true
#@export var patrol_rect: Rect2
## Start position for patrol area
@export var patrol_start_x: float = 0.0
## End position for patrol area
@export var patrol_end_x: float = 1.0

## Internal variable for checking if the entity should pursue the player
var monitor_player_position = false
var player_position = Vector2.ZERO
var camera_position := Vector2.ZERO
var sound_source_position := Vector2.ZERO
var nearest_door_position := Vector2.ZERO
var current_floor : int
var using_door: bool = false
var destination_floor: int
#var listen_for_player_coords = false

var squad_position
var patrol_target_position_x

var player_out_of_range: bool = true

#func normalize_target_position(): return target_position.normalized()


## Sets [b]squad_position[/b] to current position if [b]on_gaurd[/b] is set to true
func _ready() -> void:
	super()
	
	if on_gaurd: squad_position = position
	print(2)


func _physics_process(delta: float) -> void:
	super(delta)
	
	player_position = SceneVariables.player_position
	velocity.x = get_target_position().x * speed
	
	move_and_slide()


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
  

## If [b]patrol_area[/b] is set to true, checks if the entity has reached the end of the patrolling area
func check_for_end_of_area():
	# If position surpasses the bounds of the area, 
	# 	set target position to opposite side of area
	if position.x > patrol_end_x:
		patrol_target_position_x = patrol_start_x
	elif position.x < patrol_start_x:
		patrol_target_position_x = patrol_end_x


## Send the position the enemy should move to if the player is out of reach of the entity
func return_to_squad_position() -> Vector2:
	if player_out_of_range: return squad_position
	else: return Vector2.ZERO # Will be used to check if the entity should continue pursuing the player
