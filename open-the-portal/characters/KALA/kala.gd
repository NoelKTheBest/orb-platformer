extends CharacterBody2D

@export var fall_velocity_factor : float = 3
@export var accel : int
@export var sprite_init_point: Vector2

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0


@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	$AnimationTree.active = true
	sprite_init_point = sprite_2d.position


func _process(_delta: float) -> void:
	if sprite_2d.flip_h: sprite_2d.position = sprite_init_point * -1
	else: sprite_2d.position = sprite_init_point * 1


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: 
			velocity += get_gravity() * fall_velocity_factor * delta
		else:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if is_on_floor() and jump_buffer_timer.time_left > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer.stop()

	if is_on_floor(): set_collision_mask_value(2, true)
	else: set_collision_mask_value(2, false)
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, accel)
	else:
		velocity.x = move_toward(velocity.x, 0, accel)
	
	if direction < 0: sprite_2d.flip_h = true 
	elif direction > 0: sprite_2d.flip_h = false
	
	move_and_slide()


#func move_camera(_delta : float):
	#if enemy_pos and enemy_pos != position:
		##t += delta * 0.4
		#var _line_to_enemy : Vector2 = enemy_pos - position
		#var m = (enemy_pos.y - position.y)/(enemy_pos.x - position.x)
		#var x_mid = (enemy_pos.x - position.x)/2
		#var y = x_mid * m
		#camera_follow.position = Vector2(x_mid, y)
		##print(position.distance_squared_to(enemy_pos))
		##if position.distance_squared_to(enemy_pos) < close_zoom_range:
			##if !is_zoomed_close: $CameraFollow/AnimationPlayer.play("close_zoom")
			##is_zoomed_close = true
		##else:
			##if is_zoomed_close: $CameraFollow/AnimationPlayer.play("normal_zoom")
			##is_zoomed_close = false
		#
		## if there is only one enemy in the scene
		##	focus on enemy if they are close enough
		#if position.distance_squared_to(enemy_pos) > player_camera_focus_range:
			#camera_follow.position = Vector2.ZERO
	#else:
		#camera_follow.position = Vector2.ZERO
