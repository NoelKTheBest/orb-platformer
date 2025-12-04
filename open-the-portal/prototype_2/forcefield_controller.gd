extends CharacterBody2D

## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2

signal enemy_on_screen()
signal enemy_died()

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum enemy_state {IDLE, RUN, RECOVER, ATTACK1, ATTACK2, ATTACK3, ROLL, BLOCK, DISAPPEAR, REAPPEAR}

var monitor_player_position = false 
var player_position = Vector2.ZERO
var attacking :  bool
var on_cooldown : bool
var in_anti_gravity_zone = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

func _ready() -> void:
	monitor_player_position = false
	print(enemy_state.RECOVER)


func _process(delta: float) -> void:
	if !animation_player.is_playing(): animation_player.play("idle")
	if velocity.x < 0: 
		sprite_2d.flip_h = true
		$Hitbox.position = Vector2(-18, 3)
	elif velocity.x > 0: 
		sprite_2d.flip_h = false
		$Hitbox.position = Vector2(18, 3)


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
		if !attacking:
			if velocity.x != 0:
				animation_player.play("run")
			elif velocity.x == 0:
				animation_player.play("idle")
			$Hitbox.visible = false
			$Hitbox.set_collision_layer_value(1, false)
		else:
			if !on_cooldown:
				animation_player.play('block')
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
	if anim_name == "block":
		$Timer.start()
		on_cooldown = true
		attacking = false


func _on_timer_timeout() -> void:
	on_cooldown = false


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		body.queue_free()
		die()


func _on_bullet_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		pass
