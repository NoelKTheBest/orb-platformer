@abstract extends CharacterBody2D

@export var speed = 2

func _physics_process(delta: float) -> void:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		#normalize_target_position()
		
		# Set default behaviour to not move
		velocity.x = move_toward(velocity.x, 0, speed)
		
		move_and_slide()
