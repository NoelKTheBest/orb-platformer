extends CharacterBody2D

## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2
@export var min_req_for_helping = 3 # n amount of enemies left
@export var protection_vector := Vector2.ZERO

signal enemy_on_screen()
signal enemy_died()
signal controller_dead()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum enemy_state {
	IDLE, RUN, RUN_AWAY, RECOVER, ATTACK1, ATTACK2, 
	ATTACK3, ROLL, BLOCK, DISAPPEAR, REAPPEAR, SHOCKED,
	HURT, PROTECT
}
var current_state = enemy_state.IDLE
var monitor_player_position = false
var return_point_x
var number_of_enemies = 1
var player_position = Vector2.ZERO
var attacking :  bool
var recovering : bool
var on_cooldown : bool
var in_anti_gravity_zone = false
var walking = false
var health = 3

@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var player_attack_area: Area2D = $PlayerAttackArea
@onready var enemy_health_bar: Control = $EnemyHealthBar

func _ready() -> void:
	monitor_player_position = false
	attacking = false
	recovering = false
	current_state = enemy_state.IDLE
	$BulletDetectionRange.set_collision_mask_value(6, true)


func _process(_delta: float) -> void:
	#print(enemy_state.keys()[current_state])
	#if animation_player.current_animation != "shocked":
		#if !animation_player.is_playing(): animation_player.play("idle")
	
	#if number_of_enemies < 3:
	if velocity.x != 0:
		if velocity.x < 0: 
			sprite_2d.flip_h = true
			$Hitbox1.position = Vector2(-28, 0)
		elif velocity.x > 0: 
			sprite_2d.flip_h = false
			$Hitbox1.position = Vector2(28, 0)
		
		sprite_2d.position = Vector2(-17, -1) if sprite_2d.flip_h else Vector2(17, -1)
		#$BulletDetectionRange.set_collision_mask_value(6, true)
	elif velocity.x == 0:
		sprite_2d.position = Vector2(-17, -1) if sprite_2d.flip_h else Vector2(17, -1)
		#$BulletDetectionRange.set_collision_mask_value(6, true)
	
	if attacking: 
		current_state = enemy_state.ATTACK3
		sprite_2d.position = Vector2(-17, -1) if sprite_2d.flip_h else Vector2(17, -1)
	
	if true:  #RUN AWAY
		pass
	
	
	#print(enemy_state.keys()[current_state])


func _physics_process(delta: float) -> void:
	if (current_state != enemy_state.SHOCKED):
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		#if current_state == enemy_state.PROTECT:
			#velocity.x = move_toward(velocity.x, 0, speed)
			#animation_player.play("idle")
		if !attacking:
			if monitor_player_position: # and number_of_enemies < min_req_for_helping:
				var _direction
				var target_position = (player_position - position).normalized()
				var _distance_to = position.distance_squared_to(player_position)
				
				velocity.x = target_position.x * speed
		# If the entity is currently attacking:
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if player_attack_area.has_overlapping_bodies() and monitor_player_position:
			if !recovering:
				attacking = true
			else:
				attacking = false
		
		move_and_slide()
	
	print(speed)
	print(attacking)


func die():
	enemy_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func take_damage():
	SfxSpawner.set_player(position, 1)
	VfxSpawner.set_player(position)
	health -= 1
	enemy_health_bar.update_health(health)
	if health == 0:
		enemy_health_bar.update_health(health)
		controller_dead.emit()
		die()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs") and current_state != enemy_state.PROTECT:
		body.queue_free()
		take_damage()


func _on_bullet_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs") and current_state != enemy_state.RECOVER and current_state != enemy_state.ATTACK3:
		current_state = enemy_state.BLOCK
		#animation_player.play("block")
		#$BulletDetectionRange.set_collision_mask_value(6, true)
	elif body.is_in_group("Power Orbs") and current_state != enemy_state.RECOVER:
		current_state = enemy_state.ATTACK3
		#animation_player.play("attack_3")
		#animation_player.seek(0.2, true)
		attacking = true


func _on_recover_timer_timeout() -> void:
	current_state = enemy_state.IDLE


func _on_hitbox_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"): body.queue_free()
	if body.is_in_group("Power Orbs"): body.queue_free()
	if current_state != enemy_state.ATTACK3 and current_state != enemy_state.RECOVER:
		if body.is_in_group("Orbs"): body.queue_free()
	
	if current_state != enemy_state.RECOVER:
		if body.is_in_group("Power Orbs"): body.queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "EMP":
		print_rich("[color=lightgreen]You got me!")
		#animation_player.play("shock")
		current_state = enemy_state.SHOCKED
	elif area.name == "BombBlastRadius":
		take_damage()
	elif area.name == "SwordHitBox":
		take_damage()
	elif area.name == "RaycastArea":
		area.queue_free()
		take_damage()


func _on_protect_timer_timeout() -> void:
	var all_enemies = get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible)
	var min_dist = 1000000000
	var closest_enemy
	var direction = 0
	var teleport_position_x = position.x
	for enemy in all_enemies:
		if abs(enemy.position.x - player_position.x) < min_dist:
			closest_enemy = enemy
			min_dist = abs(enemy.position.x - player_position.x)
			
			if enemy.position.x > player_position.x:
				direction = -1
			elif enemy.position.x < player_position.x:
				direction = 1
			
			teleport_position_x = closest_enemy.position.x + (protection_vector.x * direction)
	
	
	
	position.x = teleport_position_x if closest_enemy else teleport_position_x + (protection_vector.x * direction)
	current_state = enemy_state.PROTECT
	
	if closest_enemy:
		closest_enemy.wait_timer.start()
		closest_enemy.is_being_commanded = true
	
	await get_tree().create_timer(2.5).timeout
	
	current_state = enemy_state.IDLE


func enemy_is_visible(enemy):
	if enemy.visible_on_screen_notifier_2d.is_on_screen(): return enemy


func _on_state_machine_animation_finished(anim_name: StringName) -> void:
	if anim_name == "recover":
		recovering = false
		#$BulletDetectionRange.set_collision_mask_value(6, false)
	elif anim_name == "block":
		current_state = enemy_state.IDLE
		#$BulletDetectionRange.set_collision_mask_value(6, true)
	elif anim_name == "shock":
		current_state = enemy_state.IDLE
	elif anim_name == "attack_3":
		recovering = true
		attacking = false
