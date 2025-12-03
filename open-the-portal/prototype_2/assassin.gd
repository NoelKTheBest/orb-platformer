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
@export var launch_velocity : int
@export var zero_gravity_deceleration : int

var monitor_player_position = false
var player_position = Vector2.ZERO
var attacking :  bool
var on_cooldown : bool
var in_anti_gravity_zone = false
var zero_gravity_decel_easing : float
var attack_count = 0
var attack_anim_playing


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitor_player_position = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Sprite2D2.position = player_position
	
	if !anim_player.is_playing(): anim_player.play("idle")
	if velocity.x < 0: 
		sprite.flip_h = true
		$Hitbox.position = Vector2(-14, 1)
		player_attack_area.position = Vector2(2, 0)
	elif velocity.x > 0: 
		sprite.flip_h = false
		$Hitbox.position = Vector2(17, 1)
		player_attack_area.position = Vector2.ZERO


func _physics_process(delta: float) -> void:
	if !in_anti_gravity_zone:
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# When the player enters the first bubble, enemy movement is triggered
		#	The enemy will always move when the player is inside the first bubble
		#if player_position: monitor_player_position = true
		#print("enemy's player position: ", player_position)
		
		if monitor_player_position:
			var _direction
			var target_position = (player_position - position).normalized()
			var _distance_to = position.distance_squared_to(player_position)
			
			velocity.x = target_position.x * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

		# When the player enters the second bubble, the enemy begins it's attack cycle
		#	The enemy will continuously attack the player with a breif cooldown in between 
		#	when the player is inside the second bubble.
		if !player_attack_area.has_overlapping_bodies() and !attacking:
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
	else:
		zero_gravity_decel_easing = 3 if velocity.y > -200 else 1
		if velocity.y > -27:
			zero_gravity_decel_easing = 4
			velocity.y = move_toward(velocity.y, 0, zero_gravity_deceleration * zero_gravity_decel_easing * delta)
		if velocity.y > -60:
			velocity.y = move_toward(velocity.y, 0, zero_gravity_deceleration * zero_gravity_decel_easing * delta)
		else:
			velocity.y = move_toward(velocity.y, 0, zero_gravity_deceleration * zero_gravity_decel_easing)
		
		move_and_slide()


func launch():
	in_anti_gravity_zone = true
	var distance_from_player = position.distance_squared_to(player_position)
	var launch_factor = 1
	if distance_from_player < 15000:
		launch_factor = 1
	elif distance_from_player > 15000:
		launch_factor = 0.9
	velocity.y = launch_velocity * launch_factor
	#velocity.y = launch_velocity * (10000 / position.distance_squared_to(player_position))
	#print(position.distance_squared_to(player_position))


func die():
	enemy_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		body.queue_free()
		die()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "block":
		$Timer.start()
		on_cooldown = true
		attacking = false
		if attack_count < 3: attack_count += 1
	elif anim_name == "cross_slice":
		$Timer.start()
		on_cooldown = true
		attacking = false
		attack_count = 0


func _on_timer_timeout() -> void:
	on_cooldown = false
