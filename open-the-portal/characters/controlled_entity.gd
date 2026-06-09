@abstract extends CharacterBody2D
## A class meant for providing base implementation for an entity affected by gravity
## and that can move at a specified [b]speed[/b]

## Base speed of enemy
@export var speed = 2
## amount to increase speed by to differentiate it this body's speed slightly from similar entities of the same type 
var random_speed_inc


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
