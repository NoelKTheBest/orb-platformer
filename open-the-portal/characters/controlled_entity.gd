@abstract extends CharacterBody2D
## A class meant for providing base implementation for an entity affected by gravity
## and that can move at a specified [b]speed[/b]

## Base speed of enemy
@export var speed = 2
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
	random_speed_inc = randf()
	print(1)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	#normalize_target_position()
	
	# Set default behaviour to not move
	velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()


#@abstract func fart()
