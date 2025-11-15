extends CharacterBody2D

@onready var orb_spawn_position: Node2D = $OrbSpawnPosition
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_follow: Node2D = $CameraFollow
@onready var camera_2d: Camera2D = $CameraFollow/Camera2D
@onready var jump_buffer_timer: Timer = $Timer

## The distance from the enemy at which the camera will focus on the player
@export var player_camera_focus_range : float = 132551.375
@export var accel : int
@export var jump_velocity : int
@export var fall_velocity_factor : float = 3
@export var orb_velocity : float

signal orb_was_fired
signal player_died
signal anti_gravity_zone_created

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ORB_VELOCITY = 400

var orb = preload("res://scenes/orb.tscn")
var enemy_pos : Vector2
var on_cooldown = false
var in_anti_gravity_zone = false


func _process(delta: float) -> void:
	if enemy_pos: 
		move_camera(delta)
	
	if Input.is_action_just_pressed("fire") and !on_cooldown:
		var new_orb = orb.instantiate()
		
		# Set properties before node is ready to have access to them
		new_orb.position = orb_spawn_position.position
		var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
		new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY
		add_child(new_orb)
		$SpawnTimer.start()
		on_cooldown = true
		orb_was_fired.emit()
	
	if Input.is_action_just_pressed("anti-gravity_attack"):
		anti_gravity_zone_created.emit()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0: 
			velocity += get_gravity() * fall_velocity_factor * delta
		else:
			velocity += get_gravity() * delta
			

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		jump_buffer_timer.start()
	
	if is_on_floor() and jump_buffer_timer.time_left > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer.stop()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, accel)
		if is_on_floor(): $AnimationPlayer.play("Player_Movement/run")
	else:
		velocity.x = move_toward(velocity.x, 0, accel)
		if is_on_floor(): $AnimationPlayer.play("Player_Movement/idle")
	
	if direction < 0: sprite_2d.flip_h = true 
	elif direction > 0: sprite_2d.flip_h = false
	
	if velocity.y == JUMP_VELOCITY: $AnimationPlayer.play("Player_Movement/jump")
	if velocity.y > 0:
		print(velocity.y)
		$AnimationPlayer.play("Player_Movement/fall")
	
	#print(velocity.x)
	move_and_slide()


func move_camera(_delta : float):
	if enemy_pos and enemy_pos != position:
		#t += delta * 0.4
		var _line_to_enemy : Vector2 = enemy_pos - position
		var m = (enemy_pos.y - position.y)/(enemy_pos.x - position.x)
		var x_mid = (enemy_pos.x - position.x)/2
		var y = x_mid * m
		camera_follow.position = Vector2(x_mid, y)
		#print(position.distance_squared_to(enemy_pos))
		#if position.distance_squared_to(enemy_pos) < close_zoom_range:
			#if !is_zoomed_close: $CameraFollow/AnimationPlayer.play("close_zoom")
			#is_zoomed_close = true
		#else:
			#if is_zoomed_close: $CameraFollow/AnimationPlayer.play("normal_zoom")
			#is_zoomed_close = false
		
		# if there is only one enemy in the scene
		#	focus on enemy if they are close enough
		if position.distance_squared_to(enemy_pos) > player_camera_focus_range:
			camera_follow.position = Vector2.ZERO
	else:
		camera_follow.position = Vector2.ZERO


func reset_camera_follow():
	enemy_pos = position


func _on_hurtbox_player_was_hit() -> void:
	die()


func die():
	player_died.emit()


func _on_spawn_timer_timeout() -> void:
	on_cooldown = false
