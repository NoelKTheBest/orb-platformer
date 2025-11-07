extends CharacterBody2D

@onready var orb_spawn_position: Node2D = $OrbSpawnPosition
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_follow: Node2D = $CameraFollow
@onready var camera_2d: Camera2D = $CameraFollow/Camera2D
@onready var orb_spawn_cycle_position: Node2D = $Path1/PathFollow2D/OrbSpawnCyclePosition
@onready var left_enemy_detection: Area2D = $LeftEnemyDetection
@onready var right_enemy_detection: Area2D = $RightEnemyDetection


## The distance at which the camera will zoom in on the player and enemy
@export var close_zoom_range : float = 50000
## The distance from the enemy at which the camera will focus on the player
@export var player_camera_focus_range : float = 132551.375

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ORB_VELOCITY = 400

var orb = preload("res://scenes/orb.tscn")
var aim_with_move_keys: bool = false
#var aim_dir
var y_slow: float = 1
var enemy_pos : Vector2
var is_zoomed_close = false
var lerp_val
var close_zoom = 4
var normal_zoom = 3
var t = 0.0


func _process(delta: float) -> void:
	if enemy_pos: 
		move_camera(delta)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("fire"):
		var new_orb = orb.instantiate()
		
		# Set properties before node is ready to have access to them
		new_orb.position = orb_spawn_position.position
		new_orb.linear_v = aim_orb()
		add_child(new_orb)
	
	if Input.is_action_just_pressed("cycle_fire"):
		var new_orb = orb.instantiate()
	
	if Input.is_action_just_pressed("change_controls"):
		aim_with_move_keys = !aim_with_move_keys
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor(): $AnimationPlayer.play("Player_Movement/run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor(): $AnimationPlayer.play("Player_Movement/idle")
	
	if direction < 0: sprite_2d.flip_h = true 
	elif direction > 0: sprite_2d.flip_h = false
	
	if velocity.y == JUMP_VELOCITY: $AnimationPlayer.play("Player_Movement/jump")
	if velocity.y > 0: $AnimationPlayer.play("Player_Movement/fall")

	move_and_slide()


func aim_orb():
	if aim_with_move_keys:
		# Get up key value and apply y velocity multiplier
		pass
	else:
		# Get arrow key axes and shoot
		# Optionally apply y_slow
		var vertical_axis = Input.get_axis("aim_up", "aim_down")
		var horizontal_axis = Input.get_axis("aim_left", "aim_right")
		if !horizontal_axis and !vertical_axis:
			horizontal_axis = 1 if sprite_2d.flip_h == false else -1
		var aim_dir = Vector2(horizontal_axis, vertical_axis)
		aim_dir = aim_dir.normalized() * ORB_VELOCITY
		return aim_dir


func move_camera(delta : float):
	if enemy_pos and enemy_pos != position:
		#t += delta * 0.4
		var line_to_enemy : Vector2 = enemy_pos - position
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


func check_surrounding_areas():
	var eol = left_enemy_detection.has_overlapping_bodies()
	var eor = right_enemy_detection.has_overlapping_bodies()
	
	if eor and !eol:
		enemy_pos = right_enemy_detection.get_overlapping_bodies()[0].position
	elif !eor and eol:
		enemy_pos = left_enemy_detection.get_overlapping_bodies()[0].position
	elif !eor and !eol:
		# Set enemy_pos to (0,0) so it doesn't trigger the main if statement in move_camera()
		enemy_pos = position
	elif eor and eol:
		enemy_pos = position
	# if enemies are to the right and the left
	#	focus on the player
	
	# if an there are more than one enemy to the right of left
	# the script may say there is no enemy there even when there is
