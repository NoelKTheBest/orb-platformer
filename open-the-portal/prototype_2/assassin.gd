extends CharacterBody2D

signal enemy_on_screen()
signal enemy_died()

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var player_attack_area: Area2D = $PlayerAttackArea
@onready var wait_timer: Timer = $WaitTimer

## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2
@export var walk_velocity: float
@export var vision_scale: float = 1.5
@export var defend_position: bool = false

var monitor_player_position = false
var player_position = Vector2.ZERO
var attacking :  bool
var on_cooldown : bool
var attack_count = 0
var attack_anim_playing
var walking = false
var init_start_pos_x
var movement_paused = false
var is_being_commanded = false
var random_speed_inc
var bodies = []
var patrol_area = true
var camera_position := Vector2.ZERO
var sound_source_position := Vector2.ZERO
var heat_sensor_position := Vector2.ZERO
var nearest_door_position := Vector2.ZERO
var current_floor : int
var using_door: bool = false
var destination_floor: int
var listen_for_player_coords = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitor_player_position = false
	init_start_pos_x = position.x
	random_speed_inc = randf()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Sprite2D2.position = player_position
	
	if !anim_player.is_playing(): anim_player.play("idle")
	if velocity.x < 0: 
		sprite.flip_h = true
		$Hitbox.position = Vector2(-14, 1)
		player_attack_area.position = Vector2(2, 0)
		if $VisibilityArea: $VisibilityArea.scale.x = -1
	elif velocity.x > 0: 
		sprite.flip_h = false
		$Hitbox.position = Vector2(17, 1)
		player_attack_area.position = Vector2.ZERO
		if $VisibilityArea: $VisibilityArea.scale.x = 1
	
	
	# if no other position is needed
	if $VisibilityArea: set_monitor_player_status()


func _physics_process(delta: float) -> void:
	#print(monitor_player_position, " s:pp")
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
		#print(velocity.x)
		#if is_being_commanded: velocity.x = target_position.x * 10
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		#print(velocity.x)
	
	if is_being_commanded:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# When the player enters the second bubble, the enemy begins it's attack cycle
	#	The enemy will continuously attack the player with a breif cooldown in between 
	#	when the player is inside the second bubble.
	if !player_attack_area.has_overlapping_bodies() and !attacking and !walking and !movement_paused and !is_being_commanded:
		if velocity.x != 0:
			anim_player.play("run")
		elif velocity.x == 0:
			anim_player.play("idle")
		$Hitbox.visible = false
		$Hitbox.set_collision_layer_value(1, false)
	elif player_attack_area.has_overlapping_bodies() and monitor_player_position:
		if !on_cooldown:
			#anim_player.play('block')
			if attack_count < 3:
				anim_player.play('block')
				attacking = true
				#attack_count += 1
				#print(attack_count)
			elif attack_count == 3:
				anim_player.play("cross_slice")
				attacking = true
				#attack_count = 0
				#print(attack_count)
	
	#if attacking and !player_attack_area.has_overlapping_bodies():
		#attacking = false
	
	move_and_slide()


 ##function will be used to set and reset the
		##variable 'monitor_player_position' so that
		##when the enemy spots the player, that enemy
		##becomes hostile and only that enemy. Other
		##other enemies in the area will also become
		##if they see the player as well and the enemy
		##that first spots the player may have the option
		##to call for reinforcements
func set_monitor_player_status():
	#print(monitor_player_position, " s:smps")
	# Check if area 2d representing vision space has
	#	overlapping bodies (player) of check if 
	#	player's position is within a specific x and y 
	#	range
	
	# If a body overlaps, get ref to body
	if $VisibilityArea.has_overlapping_bodies():
		bodies = $VisibilityArea.get_overlapping_bodies()
	# If we still have a ref to body and no current body, go to last known pos
	elif !$VisibilityArea.has_overlapping_bodies():
		bodies = []
		if abs(position.x - player_position.x) < 5:
			patrol_area = true
			monitor_player_position = false
		# If player was seen but managed to hide again,
		#	wait 3-4 seconds and then continue with patrol cycle
		#		(Animation Tree self updates)
	
	# If we have a player body, run to them
	if bodies.size() > 0:
		monitor_player_position = true
		player_position = bodies[0].position
		patrol_area = false
		$VisibilityArea.scale.y = 1/abs(position.x - player_position.x) * vision_scale
	else:
		$VisibilityArea.scale.y = 1
	
	#print(monitor_player_position, " e:smps")


func command():
	if player_position: print(name, " is gonna block")
	is_being_commanded = true


func die():
	SfxSpawner.set_player(position, 1)
	VfxSpawner.set_player(position)
	enemy_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs") and !body.has_bullet_hit_anything:
		$AnimationPlayer.play("dodge")
		movement_paused = true
		#body.has_bullet_hit_anything = true
		
	elif body.is_in_group("Power Orbs") and !body.has_bullet_hit_anything:
		body.has_bullet_hit_anything = true
		#body.queue_free()
		#die()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "block":
		$Timer.start()
		on_cooldown = true
		attacking = false
		is_being_commanded = false
		if attack_count < 3: attack_count += 1
	elif anim_name == "cross_slice":
		$Timer.start()
		on_cooldown = true
		attacking = false
		attack_count = 0
	elif anim_name == "dodge":
		movement_paused = false
		#$AnimationPlayer.play("cross_slice")
	elif anim_name == "":
		pass


func _on_timer_timeout() -> void:
	on_cooldown = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "EMP":
		$AnimationPlayer.play("shock")
		movement_paused = true
	elif area.name == "BombBlastRadius":
		die()
	elif area.name == "SwordHitBox":
		die()
	elif area.name == "RaycastArea":
		area.queue_free()
		die()


func _on_wait_timer_timeout() -> void:
	is_being_commanded = false
