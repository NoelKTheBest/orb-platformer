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

#region Level Dependent Vars
var idle = 0
var run = 0
var attack = 0
var monitor_player_position = false
var player_position = Vector2.ZERO
var objective: Vector2
var attacking : bool
var cutscene_active = false
#endregion

var on_cooldown : bool
var walking = true
var movement_paused = false

var temp_v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitor_player_position = false
	#print($AnimationTree.tree_root.get_node_list())
	#for node in $AnimationTree.tree_root.get_node_list():
		#print($AnimationTree.tree_root.get_node(node))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Sprite2D2.position = player_position
	
	if !anim_player.is_playing(): anim_player.play("idle")
	if velocity.x < 0: 
		sprite.flip_h = true
		$Hitbox.position = Vector2(-18, 3)
	elif velocity.x > 0: 
		sprite.flip_h = false
		$Hitbox.position = Vector2(18, 3)


func _physics_process(delta: float) -> void:
	temp_v = velocity
	if !cutscene_active:
		#$AnimationTree.callback_mode_process = AnimationMixer.AnimationCallbackModeProcess.ANIMATION_CALLBACK_MODE_PROCESS_IDLE
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# When the player enters the first bubble, enemy movement is triggered
		#	The enemy will always move when the player is inside the first bubble
		#if player_position: monitor_player_position = true
		#print("enemy's player position: ", player_position)
		
		#if !walking:
		if monitor_player_position:
			var _direction
			var target_position = (player_position - position).normalized()
			var _distance_to = position.distance_squared_to(player_position)
			
			velocity.x = target_position.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		#else:
			#anim_player.play("walk")
			#@warning_ignore("integer_division")
			#velocity.x = walk_velocity * (speed / 30)

		# When the player enters the second bubble, the enemy begins it's attack cycle
		#	The enemy will continuously attack the player with a breif cooldown in between 
		#	when the player is inside the second bubble.
		if !player_attack_area.has_overlapping_bodies() and !attacking and !movement_paused:
			#$AnimationTree["parameters/SwitchToAttack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT
			#if velocity.x != 0:
				#anim_player.play("run")
			#elif velocity.x == 0:
				#anim_player.play("idle")
			$Hitbox.visible = false
			$Hitbox.set_collision_layer_value(1, false)
		elif player_attack_area.has_overlapping_bodies() and monitor_player_position:
			if !on_cooldown:
				#anim_player.play('block')
				#$AnimationTree["parameters/SwitchToAttack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
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
		
		#if idle == 1:
			#velocity.x = 0
		
		move_and_slide()


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
		#body.queue_free()
		#die()


func _on_timer_timeout() -> void:
	on_cooldown = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "EMP":
		$AnimationPlayer.play("shock")
		movement_paused = true
	elif area.name == "BombBlastRadius":
		die()
	elif area.name == "GrenadeRadius":
		$AnimationPlayer.play("blinded")
		movement_paused = true
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
		
		#$AnimationTree["parameters/SwitchToAttack/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FADE_OUT
	elif anim_name == "shock" or anim_name == "blinded":
		movement_paused = false
