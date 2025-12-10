extends CharacterBody2D

## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2

signal enemy_on_screen()
signal enemy_died()
signal controller_dead()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum enemy_state {IDLE, RUN, RUN_AWAY, RECOVER, ATTACK1, ATTACK2, ATTACK3, ROLL, BLOCK, DISAPPEAR, REAPPEAR}
var current_state = enemy_state.IDLE
var monitor_player_position = false
var return_point_x
var number_of_enemies
var player_position = Vector2.ZERO
var attacking :  bool
var on_cooldown : bool
var in_anti_gravity_zone = false
var walking = false
var health = 3

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D
@onready var player_attack_area: Area2D = $PlayerAttackArea
@onready var enemy_health_bar: Control = $EnemyHealthBar

func _ready() -> void:
	monitor_player_position = false
	current_state = enemy_state.IDLE
	$BulletDetectionRange.set_collision_mask_value(6, true)


func _process(_delta: float) -> void:
	if !animation_player.is_playing(): animation_player.play("idle")
	
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
	if !in_anti_gravity_zone:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# When the forcefield controller is not monitoring the player
		#	they will go back to a certain point in the level
		if current_state != enemy_state.RECOVER and current_state != enemy_state.BLOCK:
			if monitor_player_position and number_of_enemies < 3:
				var _direction
				var target_position = (player_position - position).normalized()
				var _distance_to = position.distance_squared_to(player_position)
				
				velocity.x = target_position.x * speed
				current_state = enemy_state.RUN
			elif monitor_player_position and number_of_enemies >= 3:
				var target_position = (Vector2(return_point_x, position.y) - position)
				if target_position.x > 30: velocity.x = target_position.normalized().x * speed
				else:
					sprite_2d.flip_h = true
					velocity.x = move_toward(velocity.x, 0, speed)
				current_state = enemy_state.RUN_AWAY
			else:
				#var _direction
				#var target_position = (player_position - position).normalized()
				#var _distance_to = position.distance_squared_to(player_position)
				#
				#velocity.x = target_position.x * speed
				velocity.x = move_toward(velocity.x, 0, speed)
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
		
		if !player_attack_area.has_overlapping_bodies() and !attacking and current_state != enemy_state.RECOVER:
			if current_state != enemy_state.BLOCK:
				if velocity.x != 0:
					animation_player.play("run")
				elif velocity.x == 0:
					animation_player.play("idle")
				$Hurtbox.visible = false
				$Hurtbox.set_collision_layer_value(1, false)
		elif player_attack_area.has_overlapping_bodies() and monitor_player_position:
			if !on_cooldown:
				animation_player.play('attack_3')
				attacking = true
		
		move_and_slide()
	else:
		#zero_gravity_decel_easing = 3 if velocity.y > -200 else 1
		#if velocity.y > -27:
			#zero_gravity_decel_easing = 4
			#velocity.y = move_toward(velocity.y, 0, zero_gravity_deceleration * zero_gravity_decel_easing * delta)
		#if velocity.y > -60:
			#velocity.y = move_toward(velocity.y, 0, zero_gravity_deceleration * zero_gravity_decel_easing * delta)
		#else:
			#velocity.y = move_toward(velocity.y, 0, zero_gravity_deceleration * zero_gravity_decel_easing)
		#print(velocity.y)
		#print(delta)
		move_and_slide()


func launch():
	pass


func die():
	enemy_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack_3":
		$Timer.start()
		on_cooldown = true
		attacking = false
		current_state = enemy_state.RECOVER
		animation_player.play("recover")
		#$BulletDetectionRange.set_collision_mask_value(6, false)
	elif anim_name == "block":
		current_state = enemy_state.IDLE
	elif anim_name == "recover":
		current_state = enemy_state.IDLE
		#$BulletDetectionRange.set_collision_mask_value(6, true)


func _on_timer_timeout() -> void:
	on_cooldown = false


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		body.queue_free()
		health -= 1
		enemy_health_bar.update_health(health)
		if health == 0:
			enemy_health_bar.update_health(health)
			controller_dead.emit()
			die()


func _on_bullet_detection_range_body_entered(body: Node2D) -> void:
	print(body.get_groups(), body.name)
	if body.is_in_group("Orbs") and current_state != enemy_state.RECOVER:
		current_state = enemy_state.BLOCK
		animation_player.play("block")
		#$BulletDetectionRange.set_collision_mask_value(6, true)
	elif body.is_in_group("Power Orbs") and current_state != enemy_state.RECOVER:
		current_state = enemy_state.ATTACK3
		animation_player.play("attack_3")
		animation_player.seek(0.2, true)
		attacking = true


func _on_recover_timer_timeout() -> void:
	current_state = enemy_state.IDLE


func _on_hitbox_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"): body.queue_free()
	if body.is_in_group("Power Orbs"): body.queue_free()
	
