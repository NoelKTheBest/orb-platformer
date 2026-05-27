extends CharacterBody2D

#region Preloads
var kickbox_scene = preload("res://game/scenes/kickbox.tscn")
#endregion

@export var fall_velocity_factor : float = 3
@export var kick_fall_factor: float = 0.4
@export var kick_fall_factor_inc: float = 10
@export var kick_fall_inc_step_val: float = 0.5
@export var x_slow_amount: float = 1
@export var accel : int
@export var sprite_init_point: Vector2

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0

var collided_enemy
var kick_fall_factor_init_val
var set_kick_true

#region AnimTreeVars
var kick_enemy: bool = false
var current_animation := ""
#endregion


@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_kick: RayCast2D = $RayCastKick
@onready var kick_hitbox: Area2D = $KickHitbox


func _ready() -> void:
	$AnimationTree.active = true
	sprite_init_point = sprite_2d.position
	kick_fall_factor_init_val = kick_fall_factor_inc


func _process(_delta: float) -> void:
	# Grab collider and save ref for later
	if kick_hitbox.has_overlapping_bodies():
		collided_enemy = kick_hitbox.get_overlapping_bodies()[0]
	
	kick_enemy = true if kick_hitbox.has_overlapping_bodies() and velocity.y > 0 else false
	if $KickFallTimer.is_stopped() and kick_enemy: $KickFallTimer.start(0.4)
	#print($KickFallTimer.time_left)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			if $KickFallTimer.time_left > 0:
				#print(velocity.y)
				velocity.y = kick_fall_factor * kick_fall_factor_inc * delta
				#breakpoint
				kick_fall_factor_inc -= kick_fall_inc_step_val
			else:
				velocity += get_gravity() * fall_velocity_factor * delta
		else:
			velocity += get_gravity() * delta
	else:
		kick_fall_factor_inc = kick_fall_factor_init_val

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
		var slow_scale = x_slow_amount if $KickFallTimer.time_left > 0 else 1.0
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED * (1.0/(slow_scale)), accel)
	else:
		velocity.x = move_toward(velocity.x, 0, accel)
	
	if $KickFallTimer.time_left == 0:
		if direction < 0: sprite_2d.flip_h = true 
		elif direction > 0: sprite_2d.flip_h = false
		sprite_2d.position = Vector2(-11, 0) if sprite_2d.flip_h else Vector2(11, 0)
	
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


func freeze_frame(time_scale: float, duration: float):

	Framefreeze.frame_freeze(time_scale, duration)


func add_kickbox():
		# Play sound effect
	# Set variable for how long the game should wait to start animating the kick
	# Allow animation to progress after hitstop
	var area = kickbox_scene.instantiate()
	#area.name = "IWasAddedToThisObject"
	# Get collider (from raycast or area)
	#var enemy = ray_cast_kick.get_collider()
	collided_enemy.add_child(area)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Kala_anims/kick":
		kick_enemy = false
	elif anim_name == "Kala_anims/fall":
		current_animation = ""


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name == "Kala_anims/fall":
		current_animation = "fall"
	else:
		current_animation = ""
