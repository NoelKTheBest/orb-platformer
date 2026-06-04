@abstract class Enemy extends CharacterBody2D:

	# Use this scene as a base to build characters with
	
	@export var temp_name: String
	
	var speed = 2
	var random_speed_inc
	
	var monitor_player_position = false
	var player_position = Vector2.ZERO
	var patrol_area = true
	var camera_position := Vector2.ZERO
	var sound_source_position := Vector2.ZERO
	var heat_sensor_position := Vector2.ZERO
	var nearest_door_position := Vector2.ZERO
	var current_floor : int
	var using_door: bool = false
	var destination_floor: int
	var listen_for_player_coords = false

	const SPEED = 300.0
	const JUMP_VELOCITY = -400.0

	var hitbox # fetch in ready
	var hurtbox # fetch in ready

	@onready var animation_player: AnimationPlayer = $AnimationPlayer
	@onready var sprite_2d: Sprite2D = $Sprite2D


	func _physics_process(delta: float) -> void:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# When the player enters the first bubble, enemy movement is triggered
		#	The enemy will always move when the player is inside the first bubble
		#if player_position: monitor_player_position = true
		#print("enemy's player position: ", player_position)
		
		if listen_for_player_coords: monitor_player_position = true
		
		if camera_position != Vector2.ZERO and listen_for_player_coords:
			player_position = camera_position
		
		if monitor_player_position:
			var target_position
			
			if nearest_door_position != Vector2.ZERO:
				if !using_door: using_door = true
				target_position = (nearest_door_position - position).normalized()
			else:
				if using_door: using_door = false
				target_position = (player_position - position).normalized()
				var _distance_to = position.distance_squared_to(player_position)
			
			# Velocity should be set outside of the if/else blocks
			velocity.x = target_position.x * (speed + random_speed_inc)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		change_state()
		change_objective()
		
		move_and_slide()


	@abstract func change_state()
	
	func change_objective():
		pass
