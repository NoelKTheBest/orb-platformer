extends CharacterBody2D

signal enemy_on_screen()
signal enemy_died()

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var player_attack_area: Area2D = $PlayerAttackArea

## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2
@export var walk_velocity: float
@export var vision_scale: float = 1.5

#region Level Dependent Vars
var idle = 0
var run = 0
var attack = 0
var monitor_player_position = false
var listen_for_player_coords = false
var player_position = Vector2.ZERO
var objective: Vector2
var attacking : bool
var cutscene_active = false
var camera_position := Vector2.ZERO
var sound_source_position := Vector2.ZERO
var heat_sensor_position := Vector2.ZERO
var nearest_door_position := Vector2.ZERO
var current_floor : int
var using_door: bool = false
#endregion

var on_cooldown : bool
var walking = true
var patrol_area = true
var bodies = []
var movement_paused = false
var shocked = false

var temp_v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitor_player_position = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Sprite2D2.position = player_position
	
	if !anim_player.is_playing(): anim_player.play("idle")
	if velocity.x < 0: 
		sprite.flip_h = true
		$Hitbox.position = Vector2(-18, 3)
		if $VisibilityArea: $VisibilityArea.scale.x = -1
	elif velocity.x > 0: 
		sprite.flip_h = false
		$Hitbox.position = Vector2(18, 3)
		if $VisibilityArea: $VisibilityArea.scale.x = 1
	
	# if no other position is needed
	if $VisibilityArea: set_monitor_player_status()


func _physics_process(delta: float) -> void:
	temp_v = velocity
	if !cutscene_active:
		
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
				#var _distance_to = position.distance_squared_to(player_position)
			
			velocity.x = target_position.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		# When the player enters the second bubble, the enemy begins it's attack cycle
		#	The enemy will continuously attack the player with a breif cooldown in between 
		#	when the player is inside the second bubble.
		if !player_attack_area.has_overlapping_bodies() and !attacking and !movement_paused:
			$Hitbox.visible = false
			$Hitbox.set_collision_layer_value(1, false)
		elif player_attack_area.has_overlapping_bodies() and monitor_player_position:
			if !on_cooldown:
				attacking = true
		
		move_and_slide()
	else:
		if monitor_player_position:
			var _direction
			var target_position = (objective - position).normalized()
			var _distance_to = position.distance_squared_to(objective)
			
			velocity.x = target_position.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

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


func die():
	SfxSpawner.set_player(position, 1)
	VfxSpawner.set_player(position)
	enemy_died.emit() 
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs") and !body.has_bullet_hit_anything:
		body.has_bullet_hit_anything = true
		body.queue_free()
		die()
	elif body.is_in_group("Power Orbs") and !body.has_bullet_hit_anything:
		body.has_bullet_hit_anything = true


func _on_timer_timeout() -> void:
	on_cooldown = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "EMP":
		movement_paused = true
		shocked = true
	elif area.name == "BombBlastRadius":
		die()
	elif area.name == "SwordHitBox":
		die()
	elif area.name == "RaycastArea":
		area.queue_free()
		die()


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "block":
		$Timer.start()
		on_cooldown = true
		attacking = false
	elif anim_name == "shock" or anim_name == "blinded":
		movement_paused = false
		shocked = false
