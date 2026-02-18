extends CharacterBody2D

@onready var orb_spawn_position: Node2D = $OrbSpawnPosition
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var camera_follow: Node2D = $CameraFollow
@onready var camera_2d: Camera2D = $CameraFollow/Camera2D
@onready var jump_buffer_timer: Timer = $JumpBufferTimer
@onready var health_bar: Control = $CanvasLayer/HealthBar

## The distance from the enemy at which the camera will focus on the player
@export var player_camera_focus_range : float = 132551.375
@export var accel : int
@export var jump_velocity : int
@export var fall_velocity_factor : float = 3
@export var orb_velocity : float
@export var energy_consumption : int = 30
@export var power_energy_consumption : int = 50
@export var knockback: Vector2
@export var walle = true # temp var for testing
@export var wall_pos_inc = 2

signal orb_was_fired
signal player_died
signal player_is_ready
signal use_door
signal item_activation_stopped

const MAX_SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ORB_VELOCITY = 400

#region private vars
var orb = preload("res://game/scenes/orb.tscn")
var power_orb = preload("res://game/scenes/power_orb.tscn")
var gun_blast_1 = preload("res://audio/Gun blast 1.wav")
var gun_blast_2 = preload("res://audio/Gun blast 4.wav")
var emp_scene = preload("res://game/emp.tscn")
var wall_scene = preload("res://game/scenes/wall.tscn")
var sword_scene = preload("res://game/scenes/sword_slash.tscn")
var enemy_pos : Vector2
var on_cooldown = false
var power_cooldown = false
var cycle_active = false
var no_energy = false
var are_we_ready = false
var ready_signal_emitted = false
var health = 3
var was_hit = false
var energy_regen = false
var emp_spawn_pos = Vector2(0, 15)
var wall_spawn_pos = Vector2(20, 0)
var item_activation_frametime = 0
var temp_delta = 0
var sword_instance
var current_item: String = ""
#endregion

@onready var conveyor_belt: Control = $UserInterface/ConveyorBelt


func _ready() -> void:
	print(self)
	item_activation_stopped.connect(_on_item_activation_stopped)
	current_item = "HP Restore"


func _process(delta: float) -> void:
	temp_delta = delta
	if enemy_pos: 
		move_camera(delta)
	
	# If energy regen is active, ensure the player isn't flagged as having no energy
	if energy_regen:
		no_energy = false
	
	if Input.is_action_just_pressed("use_door"):
		use_door.emit()
	
	if !cycle_active:
		if Input.is_action_just_pressed("fire") and !on_cooldown and !no_energy:
			# Consume returns -1 if there isn't enough energy.
			# If energy_regen is true, the consume check is skipped (short-circuit), allowing infinite fire.
			if energy_regen or $UserInterface/EnergyBar.consume(energy_consumption) != -1:
				var new_orb = orb.instantiate()
				
				# Set properties before node is ready to have access to them
				orb_spawn_position.position.x = -22 if sprite_2d.flip_h else 22
				new_orb.position = orb_spawn_position.position
				var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
				new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY
				add_child(new_orb)
				$SpawnTimer.start()
				$UserInterface/ColorRect.visible = false
				on_cooldown = true
				orb_was_fired.emit()
				$AudioStreamPlayer2D.stream = gun_blast_1
				$AudioStreamPlayer2D.play()
			
				are_we_ready = true

		if Input.is_action_just_pressed("power_fire") and !power_cooldown and !no_energy:
			# Consume returns -1 if there isn't enough energy.
			# If energy_regen is true, the consume check is skipped (short-circuit), allowing infinite fire.
			if energy_regen or $UserInterface/EnergyBar.consume(power_energy_consumption) != -1:
				var new_orb = power_orb.instantiate()
				# Set properties before node is ready to have access to them
				orb_spawn_position.position.x = -22 if sprite_2d.flip_h else 22
				new_orb.position = orb_spawn_position.position
				var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
				new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY * 1.02
				add_child(new_orb)
				$PowerSpawnTimer.start()
				$UserInterface/ColorRect2.visible = false
				power_cooldown = true
				orb_was_fired.emit()
				$AudioStreamPlayer2D.stream = gun_blast_2
				$AudioStreamPlayer2D.play()
				
				are_we_ready = true
	
	use_item(current_item)
	
	#if Input.is_action_pressed("use_item"):
		#print_rich("[color=orange]hello")
		#await item_activation_stopped
		#print_rich("[color=orangered]world")
	
	sprite_2d.self_modulate = Color("676767") if !are_we_ready else Color("ffffff")
	
	if are_we_ready and !ready_signal_emitted: 
		player_is_ready.emit()
		ready_signal_emitted = true


func _physics_process(delta: float) -> void:
	if !was_hit:
		# Add the gravity.
		if not is_on_floor():
			if velocity.y > 0: 
				velocity += get_gravity() * fall_velocity_factor * delta
			else:
				velocity += get_gravity() * delta
				

		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			jump_buffer_timer.start()
		
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
			if is_on_floor(): $AnimationPlayer.play("Player_Movement/run")
		else:
			velocity.x = move_toward(velocity.x, 0, accel)
			if is_on_floor(): $AnimationPlayer.play("Player_Movement/idle")
		
		if direction < 0: sprite_2d.flip_h = true 
		elif direction > 0: sprite_2d.flip_h = false
		
		if velocity.y == JUMP_VELOCITY: $AnimationPlayer.play("Player_Movement/jump")
		if velocity.y > 0:
			#print(velocity.y)
			$AnimationPlayer.play("Player_Movement/fall")
		
		#print(velocity.x)
		move_and_slide()
	else:
		
		move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventKey and !event.is_pressed() and event.is_action("use_item") and current_item == "Wall":
		item_activation_stopped.emit()
	if event.is_action_pressed("use_item"):
		# Check if item was successfully used before activating power-up
		if conveyor_belt.use_item():
			print("Using item - Energy Regen activated!")
			$UserInterface/EnergyBar.value = $UserInterface/EnergyBar.max_value
			energy_regen = true
			$EnergyRegenTimer.start()
		else:
			print("No items in inventory!")


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


func use_item(item_name: String):
	match item_name:
		"EMP":
			if Input.is_action_just_pressed("use_item") and is_on_floor():
				var new_emp = emp_scene.instantiate()
				new_emp.position = emp_spawn_pos
				add_child(new_emp)
				are_we_ready = true
				var mother = get_parent()
				new_emp.reparent(mother)
		"Wall":
			if Input.is_action_just_pressed("use_item") and is_on_floor() and !walle:
				#print_rich("[color=lightblue]just pressed")
				var new_wall = wall_scene.instantiate()
				var mult = -1 if sprite_2d.flip_h == true else 1 
				new_wall.position = wall_spawn_pos * mult
				add_child(new_wall)
				are_we_ready = true
				var mother = get_parent()
				new_wall.reparent(mother)
			elif Input.is_action_pressed("use_item") and is_on_floor() and walle:
				$ItemActivationTimer.start()
				item_activation_frametime += 1
				print_rich("[color=lightgreen]" + str(item_activation_frametime), "; ", "[color=lightblue]" + str(item_activation_frametime * temp_delta * 5))
				#await item_activation_stopped
				$WallIndicator.visible = true
				var mult = -1 if sprite_2d.flip_h == true else 1
				$WallIndicator.position.x = (20 + wall_pos_inc * item_activation_frametime * temp_delta) * mult
		"Sword":
			if Input.is_action_just_pressed("use_item") and is_on_floor():
				if not sword_instance:
					var new_sword = sword_scene.instantiate()
					var mult = -1 if sprite_2d.flip_h == true else 1 
					new_sword.position = Vector2(15, 0) * mult
					add_child(new_sword)
					sword_instance = new_sword
					sword_instance.flip_h = sprite_2d.flip_h
					sword_instance.play_anim()
					are_we_ready = true
				else:
					var mult = -1 if sprite_2d.flip_h == true else 1
					sword_instance.position = Vector2(15, 0) * mult
					sword_instance.flip_h = sprite_2d.flip_h
					sword_instance.play_anim()
					are_we_ready = true # might not be needed
		"Flash Grenade":
			pass
		"Bomb":
			pass
		"HP Restore":
			if Input.is_action_just_pressed("use_item") and is_on_floor():
				health = 3
				health_bar.update_health(health)
		"Energy Restore":
			pass



# For use with wall item
func _on_item_activation_stopped():
	var new_wall = wall_scene.instantiate()
	var mult = -1 if sprite_2d.flip_h == true else 1
	var wall_pos = Vector2(wall_spawn_pos.x + (wall_pos_inc * item_activation_frametime * temp_delta), 0) * mult
	new_wall.position = wall_pos
	add_child(new_wall)
	are_we_ready = true
	var mother = get_parent()
	new_wall.reparent(mother)
	item_activation_frametime = 0
	temp_delta = 0
	$WallIndicator.visible = false


func _on_hurtbox_player_was_hit(collision_vector: Vector2) -> void:
	$CameraFollow/Camera2D.apply_shake()
	set_collision_layer_value(1, false)
	was_hit = true
	$AnimationPlayer.play("hit")
	velocity.x = collision_vector.normalized().x * knockback.x
	velocity.y = -knockback.y
	health -= 1
	health_bar.update_health(health)
	if health == 0:
		health_bar.update_health(health)
		die()


func die():
	player_died.emit()


func _on_spawn_timer_timeout() -> void:
	on_cooldown = false
	$UserInterface/ColorRect.visible = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		set_collision_layer_value(1, true)
		was_hit = false


func _on_power_spawn_timer_timeout() -> void:
	power_cooldown = false
	$UserInterface/ColorRect2.visible = true


func _on_area_2d_body_entered(_body: CharacterBody2D) -> void:
	# Energy regen powerup test
	$UserInterface/EnergyBar.value = $UserInterface/EnergyBar.max_value
	energy_regen = true
	
	# Start the timer before awaiting
	$EnergyRegenTimer.start()
	
	await $EnergyRegenTimer.timeout
	energy_regen = false


func _on_item_activation_timer_timeout() -> void:
	print("ready")
