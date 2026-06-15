@abstract extends ControlledEntity
## This class is meant to provide functions and some basic implementation to 
## allow the entity to choose a position to go towards

## Determines if entity should walk from position to position in an area and
## waiting to see if the player enters their FOV. Overrides [b]monitor_player_position[/b]
@export var on_patrol = true
## Determines if entity should stay in position as part of a squadron. Overrides [b]on_patrol[/b]
@export var on_guard := true
@export_group("Patrol")
@export var patrol_wait := 1.0
@export_subgroup("Patrol Bounds")
## Start position for patrol area
@export var patrol_start := Vector2.ZERO
## End position for patrol area
@export var patrol_end := Vector2.ZERO
@export_group("Guard Bounds")
## Start position for guard bounds
@export var guard_bound_start: float
## End position for guard bounds
@export var guard_bound_end: float


## Internal variable for checking if the entity should pursue the player
var monitor_player_position = false
## Internal variable for player's position
var player_position = Vector2.ZERO
## Not in use
var camera_position := Vector2.ZERO
## Not in use
var sound_source_position := Vector2.ZERO
## Position of nearest door that gets the entity closer to player
var nearest_door_position := Vector2.ZERO
## Number of the floor the entity is currently on
var current_floor : int
## Determines whether the entity is trying to use a door or not
var using_door: bool = false
## Number of the destination floor the entity wants to reach
var destination_floor: int
#var listen_for_player_coords = false

## Initial position of entity if [b]on_guard[/b] is true
var squad_position
## Determines whether the entity was initially on guard at the start of the scene
var initially_guarding := false
## Determines whether the entity was initially patrolling at the start of the scene
var initially_patrolling := false
## Not in use
var patrol_target_position: Vector2


var player_out_of_range: bool = true

#func normalize_target_position(): return target_position.normalized()


## Sets [b]squad_position[/b] to current position if [b]on_guard[/b] is set to true
func _ready() -> void:
	super()
	
	if on_patrol:
		initially_patrolling = true
		# Make sure patrol bounds are set
		# Add in a wait period so the entity, stays at a location for a bit and then turns around and walks the other way
		# default bounds to keep the enemies understanding their position and state
		patrol_start = position - Vector2(40, 0)
		patrol_end = position + Vector2(40, 0)
		
		# Add a VisibilityArea node as default. If added manually, I can change the shape and size of the area if needed
		var visibility_area = load("res://game/scenes/visibility_area.tscn")
		var new_visibility_area = visibility_area.instantiate()
		add_child(new_visibility_area)
	
	# guard state should overrride patrol state
	if on_guard:
		squad_position = position
		initially_guarding = true
		# use magic numbers for now to make the logic easier to understand and implement
		# default bounds to keep the enemies understanding their position and state
		guard_bound_start = position.x - 75
		guard_bound_end = position.x + 75
		
		# Add GuardArea node as default. If added manually, I can change slightly the size or shape of the area if i so choose
		var guard_area = load("res://game/scenes/guard_area.tscn")
		var new_guard_area = guard_area.instantiate()
		add_child(new_guard_area)
	
	print(2)


func _physics_process(delta: float) -> void:
	super(delta)
	
	if on_patrol:
		monitor_player_position = false
		
		velocity.x = patrol_target_position.normalized().x * (speed / 2)
		check_for_end_of_area()
	
	if initially_guarding:
		# if we are on guard, we should stay that way for the entire frame so everything that needs to happen bc of it is predictable
		if on_guard:
			monitor_player_position = false # do not pursue player
			on_patrol = false # do not patrol area
			
			# return to squad_position
			velocity.x = (squad_position - position).normalized().x * speed
		else:
			monitor_player_position = true # pursue player if they get too close
	
	player_position = SceneVariables.player_position
	velocity.x = get_target_position().x * speed
	
	move_and_slide()
	
	# move to basic entity if we need to make sure basic entity doesn't override this code
	# If entity is outside of guard bounds
	if (position.x < guard_bound_start or position.x > guard_bound_end):
		# and was initially guarding and not on_guard
		if initially_guarding and !on_guard:
			on_guard = true # Go back to guard position (squad_position)


## Function to implement to set the target position of the entity based on position relative to player
func get_target_position() -> Vector2:
	var target_position: Vector2 = position
	
	if monitor_player_position: # and number_of_enemies < min_req_for_helping:
		if nearest_door_position != Vector2.ZERO:
			if !using_door: using_door = true
			target_position = (nearest_door_position - position).normalized()
		else:
			if using_door: using_door = false
			target_position = (player_position - position).normalized()
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed) # remove lines
		# We should be setting target position to something that will force the enemy to stay in place and then not move
	
	return target_position
  

## If [b]on_patrol[/b] is set to true, checks if the entity has reached the end of the patrolling area
func check_for_end_of_area():
	# If position surpasses the bounds of the area, 
	# 	set target position to opposite side of area
	if position.x > patrol_end.x:
		patrol_target_position.x = patrol_start.x
	elif position.x < patrol_start.x:
		patrol_target_position.x = patrol_end.x


## Send the position the enemy should move to if the player is out of reach of the entity
func return_to_squad_position() -> Vector2:
	if player_out_of_range: return squad_position
	else: return Vector2.ZERO # Will be used to check if the entity should continue pursuing the player
