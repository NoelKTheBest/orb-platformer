extends CharacterBody2D

@export var speed = 2

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


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

var player_nearby: bool
var dodge_orb: bool
var kicked: bool
var player_about_to_kick
var prev_x_velocity = 0

@onready var sprite: Sprite2D = $Sprite2D
@onready var player_attack_area: Area2D = $PlayerAttackArea


func _ready() -> void:
	random_speed_inc = randf()


func _process(_delta: float) -> void:
	if !kicked: 
		if velocity.x < 0: 
			sprite.flip_h = true
			$Hitbox.position = Vector2(-11, 0)
			#player_attack_area.position = Vector2(2, 0)
			if $VisibilityArea: $VisibilityArea.scale.x = -1
		elif velocity.x > 0: 
			sprite.flip_h = false
			$Hitbox.position = Vector2(11, 0)
			#player_attack_area.position = Vector2.ZERO
			if $VisibilityArea: $VisibilityArea.scale.x = 1
	
	# if no other position is needed
	#if $VisibilityArea: set_monitor_player_status()
	if $Kickbox:
		kicked = true
	else:
		kicked = false


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
		#print(velocity.x)
		#if is_being_commanded: velocity.x = target_position.x * 10
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		#print(velocity.x)
		
	
	if kicked and $Kickbox: velocity.x = $Kickbox.knockback.x * 1 if player_position.x < position.x else $Kickbox.knockback.x * -1
	
	player_nearby = true if player_attack_area.has_overlapping_bodies() else false

	move_and_slide()
	
	
	
	prev_x_velocity = velocity.x


func die():
	SfxSpawner.set_player(position, 1)
	VfxSpawner.set_player(position)
	#enemy_died.emit()
	queue_free()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs") and !body.has_bullet_hit_anything:
		dodge_orb = true
	elif body.is_in_group("Power Orbs") and !body.has_bullet_hit_anything:
		body.has_bullet_hit_anything = true


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "RaycastArea":
		area.queue_free()
		die()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Assassin_Anims/dodge":
		dodge_orb = false
	elif anim_name == "Assassin_Anims/kicked":
		if $Kickbox: $Kickbox.queue_free()


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name == "Assassin_Anims/kicked":
		print("i was kicked")
