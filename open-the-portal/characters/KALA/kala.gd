extends CharacterBody2D

const DEBUG = false  # Set to false to disable all debug operations

signal orb_was_fired
@warning_ignore("unused_signal")
signal player_died

#region Preloads
var kickbox_scene = preload("res://game/scenes/kickbox.tscn")
var aerial_normal_bullet_scene = preload("res://game/scenes/aerial_normal_bullet.tscn")
var gun_blast_1 = preload("res://rss/audio/Gun blast 1.wav")
var gun_blast_2 = preload("res://rss/audio/Gun blast 4.wav")
var orb = preload("res://game/scenes/orb.tscn")
#endregion

## The distance from the enemy at which the camera will focus on the player
@export var player_camera_focus_range : float = 132551.375
@export var fall_velocity_factor : float = 3
@export var kick_fall_factor: float = 0.4
@export var kick_fall_factor_inc: float = 10
@export var kick_fall_inc_step_val: float = 0.5
@export var x_slow_amount: float = 1
@export var accel : int
@export var sprite_init_point: Vector2
@export var kick_fall_timer_time: float = 0.4

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const L_FOOTSTOOL_VELOCITY_X = 700.0
const L_FOOTSTOOL_VELOCITY_Y = 100.0
const ORB_VELOCITY = 475

var collided_enemies = []
var kick_fall_factor_init_val
var set_kick_true
var prev_y_velocity = 0
var lateral_footstool_queued := false
var l_footstool_direction
var closest_enemy_position := Vector2.ZERO
var temp_delta = 0
var enemy_pos : Vector2

#region AnimTreeVars
var kick_enemy: bool = false
var current_animation := ""
#endregion


@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var ray_cast_kick: RayCast2D = $RayCastKick
@onready var kick_hitbox: Area2D = $KickHitbox
@onready var footstool_area: Area2D = $FootstoolArea
@onready var orb_spawn_position: Node2D = $OrbSpawnPosition
@onready var conveyor_belt: Control = $UserInterface/ConveyorBelt
@onready var camera_follow: Node2D = $CameraFollow


func _ready() -> void:
	$AnimationTree.active = true
	sprite_init_point = sprite_2d.position
	kick_fall_factor_init_val = kick_fall_factor_inc
	$CameraFollow/Camera2D.limit_top = position.y - 150


func _process(delta: float) -> void:
	# Grab collider and save ref for later
	if kick_hitbox.has_overlapping_bodies():
		collided_enemies = kick_hitbox.get_overlapping_bodies()
		#print(collided_enemies)
	
	kick_enemy = true if kick_hitbox.has_overlapping_bodies() and velocity.y > 0 else false
	if $KickFallTimer.is_stopped() and kick_enemy:
		$KickFallTimer.start(kick_fall_timer_time)
	
	find_closest_enemy()
	
	$ClosestEnemyRaycast.target_position = to_local(closest_enemy_position)
	
	$RayCast2D.target_position.x = 205 if !$Sprite2D.flip_h else -205
	#$RayCast2D.visible = false
	$RailgunBeam.scale.x = 12.855 if !$Sprite2D.flip_h else -12.855
	$RailgunBeam.visible = false
	
	temp_delta = delta
	if enemy_pos:
		move_camera_d(delta)
	
	#if DEBUG:
		#if Input.is_action_just_pressed("never_set_ready"):
			#never_ready = !never_ready
			#print("never ready: ", never_ready)
	
	if Input.is_action_just_pressed("instant_fire") and $RayCast2D.is_colliding() and $UserInterface/Node.use_energy(8) != -1:
		$RailgunBeam.visible = true
		var new_ray_area = Area2D.new()
		var new_ray_collider = CollisionShape2D.new()
		new_ray_collider.shape = CircleShape2D.new()
		new_ray_collider.shape.radius = 2.5
		new_ray_area.add_child(new_ray_collider)
		new_ray_area.set_collision_layer_value(1, false)
		new_ray_area.set_collision_layer_value(5, true)
		new_ray_area.set_collision_mask_value(1, false)
		new_ray_area.set_collision_mask_value(2, true)
		new_ray_area.position = to_local($RayCast2D.get_collision_point())
		new_ray_area.name = "RaycastArea"
		add_child(new_ray_area)
		$AudioStreamPlayer2D.stream = gun_blast_2
		$AudioStreamPlayer2D.play()
	
	if Input.is_action_just_pressed("fire"):
		# Consume returns -1 if there isn't enough energy.
		if $UserInterface/Node.use_energy(0) != -1:
			var new_orb = orb.instantiate()
			
			# Set properties before node is ready to have access to them
			orb_spawn_position.position.x = -22 if sprite_2d.flip_h else 22
			new_orb.position = orb_spawn_position.position
			var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
			new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY
			add_child(new_orb)
			orb_was_fired.emit()
			$AudioStreamPlayer2D.stream = gun_blast_1
			$AudioStreamPlayer2D.play()
		
	#if Input.is_action_just_pressed("power_fire") and !power_cooldown and !no_energy:
		## Consume returns -1 if there isn't enough energy.
		#if $UserInterface/Node.use_energy(8) != -1:
			#var new_orb = power_orb.instantiate()
			## Set properties before node is ready to have access to them
			#orb_spawn_position.position.x = -22 if sprite_2d.flip_h else 22
			#new_orb.position = orb_spawn_position.position
			#var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
			#new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY * 1.02
			#add_child(new_orb)
			#var mother = get_parent()
			#new_orb.reparent(mother)
			#$PowerSpawnTimer.start()
			#power_cooldown = true
			#orb_was_fired.emit()
			#$AudioStreamPlayer2D.stream = gun_blast_2
			#$AudioStreamPlayer2D.play()
			#
			#if !never_ready: are_we_ready = true
	
	if Input.is_action_just_pressed("advance_belt"):
		conveyor_belt.advance_belt()
	
	#if conveyor_belt.get_slot_content(0) != 0:
		#current_item = ItemNameDictionary.ITEM_NAMES.get(conveyor_belt.get_slot_content(0))
		#check_for_use_item(current_item)


func _physics_process(delta: float) -> void:
	#region Y Velocity Handling
	# When the player is in the air
	if not is_on_floor():
		# When the player is falling
		if velocity.y > 0:
			if $KickFallTimer.time_left > 0:
				#print(velocity.y)
				velocity.y = kick_fall_factor * kick_fall_factor_inc * delta
				#breakpoint
				kick_fall_factor_inc -= kick_fall_inc_step_val
			else:
				velocity += get_gravity() * fall_velocity_factor * delta
			
			if Input.is_action_just_pressed("jump"):
				if !footstool_area.has_overlapping_bodies():
					# This will put the player in a slightly different fall animation
					# that will automatically connect to the footstool animation state
					# when the player gets close enough to the enemies
					lateral_footstool_queued = true
				elif footstool_area.has_overlapping_bodies() and !lateral_footstool_queued:
					velocity.y = JUMP_VELOCITY
					print(footstool_area.get_overlapping_bodies()[0])
			
			if current_animation == "l_footstool":
				velocity.y = L_FOOTSTOOL_VELOCITY_Y
			
		# When the player is rising
		else:
			velocity += get_gravity() * delta
		
		# Do this regardless of whether the player is rising or falling
		#region Todo regardless
		$KickHitbox.monitorable = true
		if Input.is_action_just_pressed("jump") and !$FootstoolArea.has_overlapping_bodies():
			lateral_footstool_queued = true
		
		set_collision_mask_value(2, false)
		#endregion
	# When the player is grounded
	else:
		kick_fall_factor_inc = kick_fall_factor_init_val
		$KickHitbox.monitorable = false
		#print_rich("[color=limegreen]--------------------------------------------------------")
		
		#region Jump Handling
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			#SfxSpawner.set_player(position, 4)

		if jump_buffer_timer.time_left > 0:
			velocity.y = JUMP_VELOCITY
			jump_buffer_timer.stop()
		#endregion
		
		set_collision_mask_value(2, true)
		lateral_footstool_queued = false
		current_animation = ""
	#endregion
	
	#region X Velocity Handling
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		var slow_scale = x_slow_amount if $KickFallTimer.time_left > 0 else 1.0
		# l_footstool_direction only has direction is direction is not 0.0
		# the player won't go anywhere if they don't input a direction to go in
		if current_animation == "l_footstool" and l_footstool_direction == null:
			l_footstool_direction = direction
			velocity.x = l_footstool_direction * L_FOOTSTOOL_VELOCITY_X
		# on the frame after l_footstool_direction is set to direction, it is possible
		# to change the direction again
		else:
			l_footstool_direction = null
			velocity.x = move_toward(velocity.x, direction * MAX_SPEED * (1.0/(slow_scale)), accel)
	else:
		if current_animation == "l_footstool" and l_footstool_direction == null:
			# the assignment of l_footstool_direction depends on the value of
			# sprite_2d.flip_h from the previous frame since the value is not changed
			# before l_footstool_direction is assigned
			l_footstool_direction = -1 if sprite_2d.flip_h else 1 # value should be reset
			velocity.x = l_footstool_direction * L_FOOTSTOOL_VELOCITY_X
		velocity.x = move_toward(velocity.x, 0, accel)
	
	# Use this line to debug l_footstool_direction
	print("lfd: ", l_footstool_direction, "; dir: ", direction, "; flip: ", sprite_2d.flip_h)
	
	# Use this line to debug current_animation
	#print(current_animation)
	
	if $KickFallTimer.time_left == 0:
		if direction < 0: sprite_2d.flip_h = true
		elif direction > 0: sprite_2d.flip_h = false
		sprite_2d.position = Vector2(-sprite_init_point.x, 0) if sprite_2d.flip_h else Vector2(sprite_init_point.x, 0)
	#endregion
	
	move_and_slide()
	
	if velocity.y == 0 and prev_y_velocity > 0:
		SfxSpawner.set_player(position, 4)
		l_footstool_direction = null # This value is so far only set when direction is changed or when landing
		print("landed")
		
	
	$Polygon2D.visible = true if lateral_footstool_queued else false
	prev_y_velocity = velocity.y


func move_camera():
	$CameraFollow/Camera2D.limit_top = position.y - 200
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


func move_camera_d(_delta : float):
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


func freeze_frame(time_scale: float, duration: float):
	Framefreeze.frame_freeze(time_scale, duration)


func play_sfx(id: int):
	match id:
		0:
			SfxSpawner.set_player(position, 0)
			SfxSpawner.set_player(position, 5)
			#SfxSpawner.set_player(position, 2)
			SfxSpawner.set_player(position, 15)


func add_kickbox():
	# Play sound effect
	# Set variable for how long the game should wait to start animating the kick
	# Allow animation to progress after hitstop
	
	#area.name = "IWasAddedToThisObject"
	# Get collider (from raycast or area)
	#var enemy = ray_cast_kick.get_collider()
	for ce in collided_enemies:
		var area = kickbox_scene.instantiate()
		ce.add_child(area)


func find_closest_enemy():
	var min_d = 100000000
	for e in get_tree().get_nodes_in_group("Enemy"):
		if abs(e.position.x - position.x) < min_d:
			min_d = abs(e.position.x - position.x)
			closest_enemy_position = e.position
			#print(e.position.x, "; ", e.name, "; ", position.x)
	pass


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print("finishing anim: ", anim_name)
	if anim_name == "Kala_anims/kick":
		kick_enemy = false
	elif anim_name == "Kala_anims/fall":
		current_animation = ""
	elif anim_name == "Kala_anims/lateral_footstool":
		current_animation = ""


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	#print("current anim: ", anim_name)
	if anim_name == "Kala_anims/fall":
		current_animation = "fall"
	elif anim_name == "Kala_anims/lateral_footstool":
		current_animation = "l_footstool"
	else:
		current_animation = ""
