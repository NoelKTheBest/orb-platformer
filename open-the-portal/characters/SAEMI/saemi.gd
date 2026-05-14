extends CharacterBody2D


@export var speed := 200
@export var protection_vector := Vector2.ZERO
@export var max_bullet_block := 5
@export var lunge_speed_multiplier := 4
#const JUMP_VELOCITY = -400.0

var monitor_player_position = false
var player_position = Vector2.ZERO
var return_position = null
var hitbox_pos: Vector2
var player_nearby: bool
var bullet_nearby: bool
var is_currently_attacking: bool
var is_currently_blocking: bool
var can_protect: bool
var protect_position_x
var has_health_bar: bool = false
var was_hit: bool = false
var health = 3
var current_animation = ""
var bullets_blocked_in_a_row := 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_attack_area: Area2D = $PlayerAttackArea
@onready var hitbox: Area2D = $Hitbox
@onready var bullet_detection_area: Area2D = $BulletDetectionArea


func _ready() -> void:
	$AnimationTree.active = true
	hitbox_pos = $Hitbox.position
	if $EnemyHealthBar: has_health_bar = true


func _process(_delta: float) -> void:
	# Use the current animation to determine whether or not entity
	# should not change facing direction when getting pushed back
	if velocity.x != 0 and current_animation != "block":
		if velocity.x < 0: 
			sprite_2d.flip_h = true
			hitbox.position = hitbox_pos * Vector2(-1, 0)
		elif velocity.x > 0: 
			sprite_2d.flip_h = false
			hitbox.position = hitbox_pos * Vector2(1, 0)
		
		sprite_2d.position = Vector2(-17, -1) if sprite_2d.flip_h else Vector2(17, -1)
	elif velocity.x == 0:
		sprite_2d.position = Vector2(-17, -1) if sprite_2d.flip_h else Vector2(17, -1)
	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	if monitor_player_position: # and number_of_enemies < min_req_for_helping:
		var _direction
		var target_position = (player_position - position).normalized()
		var _distance_to = position.distance_squared_to(player_position)
				
		velocity.x = target_position.x * speed
	
	player_nearby = true if player_attack_area.has_overlapping_bodies() else false
	bullet_nearby = true if bullet_detection_area.has_overlapping_bodies() and !is_currently_attacking else false
	#if bullet_nearby and !is_currently_attacking:
		#is_currently_blocking = true
	
	if bullets_blocked_in_a_row > max_bullet_block:
		#velocity.x = move_toward(position.x, player_position.x, speed * lunge_speed_multiplier)
		set_collision_mask_value(6, false)
	
	move_and_slide()


func die():
	#enemy_died.emit()
	queue_free()


func take_damage():
	SfxSpawner.set_player(position, 1)
	VfxSpawner.set_player(position)
	health -= 1
	$EnemyHealthBar.update_health(health)
	if health == 0:
		$EnemyHealthBar.update_health(health)
		#controller_dead.emit()
		die()


# Needed to filter out enemies on screen. Remove later
func enemy_is_visible(enemy):
	if enemy.visible_on_screen_notifier_2d.is_on_screen(): return enemy


func _on_protect_timer_timeout() -> void:
	#var all_enemies = get_tree().get_nodes_in_group("Enemy").filter(func(enemy): return enemy.visible_on_screen_notifier_2d.is_on_screen())
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
	
	# We only protect the entity if they are in front of us and so is the player
	var do_we_protect = is_in_front(closest_enemy)
	print("do we protect?: ", do_we_protect)
	
	# if the enemy hasn't died: protect them
	if closest_enemy and do_we_protect: 
		#position.x = teleport_position_x
		protect_position_x = teleport_position_x
		can_protect = true
	print()
	
	#if closest_enemy:
		#closest_enemy.wait_timer.start()
		#closest_enemy.is_being_commanded = true
	
	#await get_tree().create_timer(2.5).timeout
	
	# Save for later
	#(position.x > protect_position_x && !sprite2d.flip_h) 
	#or (position.x < protect_position_x && sprite2d.flip_h)


func is_in_front(entity: Node):
	var in_front_left = sprite_2d.flip_h and entity.position.x < position.x
	var in_front_right = !sprite_2d.flip_h and entity.position.x > position.x
	#print(entity.name, ":",  entity.position.x, ":", position.x, ":", sprite_2d.flip_h)
	var p_in_front_left = player_position.x < entity.position.x and in_front_left
	var p_in_front_right = player_position.x > entity.position.x and in_front_right
	
	# True if sprite.fliph == true false otherwise
	var player_facing_left = get_parent().get_player_facing_direction()
	# Set var for attack if not facing player
	# Set var for block if facing player
	
	# For now, set only var for blocking
	
	var _facing_player_and_entity_in_front_right = in_front_right and p_in_front_right and !player_facing_left
	var _facing_player_and_entity_in_front_left = in_front_left and p_in_front_left and player_facing_left
	print()
	
	return p_in_front_left or p_in_front_right


func _on_hurtbox_body_entered(body: Node2D) -> void:
	# Do nothing if current_animation == "attack_2"
	var can_be_hit = current_animation != "block" and current_animation != "attack_2" and current_animation != "protect"
	
	if body.is_in_group("Orbs") and !body.has_bullet_hit_anything and bullets_blocked_in_a_row < 25:
		if current_animation == "block":
			body.has_bullet_hit_anything = true
			body.queue_free()
		elif can_be_hit:
			body.has_bullet_hit_anything = true
			body.queue_free()
			if $EnemyHealthBar: take_damage()
			else:
				print("ouch")


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	if anim_name == "Saemi_anims/block":
		current_animation = "block"
		bullets_blocked_in_a_row += 1
		print(bullets_blocked_in_a_row)
	elif anim_name != "Saemi_anims/block":
		bullets_blocked_in_a_row = 0
		current_animation = anim_name.get_slice("/", 1)
	
	# set current animation to attack 2
	if anim_name == "Saemi_anims/attack_2":
		current_animation = "attack_2"
	
	if anim_name == "Saemi_anims/protect":
		current_animation = "protect"


# Clear current_animation variable when a specific animation ends
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Saemi_anims/attack_1":
		if bullets_blocked_in_a_row > max_bullet_block:
			bullets_blocked_in_a_row = 0
			set_collision_mask_value(6, true)
	
	if anim_name == "Saemi_anims/dash":
		can_protect = false
	
	if anim_name == "Saemi_anims/protect":
		current_animation = ""
	
	if anim_name == "Saemi_anims/hurt":
		was_hit = false
		if return_position: position.x = return_position.x
		else: print("hide")


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "RaycastArea":
		area.queue_free()
		if $EnemyHealthBar: take_damage()
		else: print("ouch")
		was_hit = true
