@abstract extends CharacterBody2D
## A class meant for providing base implementation for an entity affected by gravity
## and that can move at a specified [b]speed[/b]

## Base speed of enemy
@export var speed = 2
@export_group("Random Speed Increase")
@export var range_bottom := 0.1
@export var range_top := 1.0
## amount to increase speed by to differentiate it this body's speed slightly from similar entities of the same type 
var random_speed_inc
## Used to check for sudden changes in x velocity
var prev_x_velocity = 0.0
## Used to check for sudden changes in y velocity
var prev_y_velocity = 0.0
## Initial position for player hitboxes
var hitbox_init_pos : Vector2
## Initial position for collider
var collider_init_pos: Vector2
## Initial position for hurtbox
var hurtbox_init_pos: Vector2


## Sets random_speed_inc for entity
func _ready() -> void:
	random_speed_inc = randf_range(range_bottom, range_top)
	speed *= random_speed_inc
	print(1)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#normalize_target_position()
	
	# Set default behaviour to not move
	velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
	
	# Detect change in velocity to make play impact sounds and vfx
	if velocity.x == 0 and prev_x_velocity != 0:
		impact()
	
	if velocity.y == 0 and prev_y_velocity != 0:
		land_on_ground()
	
	prev_x_velocity = velocity.x
	prev_y_velocity = velocity.y


func impact():
	print("Play sfx and vfx")


func land_on_ground():
	print("Play sfx")


func has_child(child_name: StringName):
	var children = get_children()
	
	for c in children:
		if c.name == child_name:
			return true
	
	return false
