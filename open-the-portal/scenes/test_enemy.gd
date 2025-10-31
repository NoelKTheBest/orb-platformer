extends CharacterBody2D

signal enemy_on_screen()
signal enemy_died()

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D

var monitor_player_position
var player_position
var attacking :  bool
var on_cooldown : bool
## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !anim_player.is_playing(): anim_player.play("idle")
	if velocity.x < 0: sprite.flip_h = true
	elif velocity.x > 0: sprite.flip_h = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# When the player enters the first bubble, enemy movement is triggered
	#	The enemy will always move when the player is inside the first bubble
	if monitor_player_position:
		var direction
		var target_position = (player_position - position).normalized()
		var distance_to = position.distance_squared_to(player_position)
		
		velocity.x = target_position.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# When the player enters the second bubble, the enemy begins it's attack cycle
	#	The enemy will continuously attack the player with a breif cooldown in between 
	#	when the player is inside the second bubble.
	if !attacking:
		if velocity.x != 0:
			anim_player.play("run")
		elif velocity.x == 0:
			anim_player.play("idle")
	else:
		if !on_cooldown:
			anim_player.play('block')
	
	move_and_slide()


func die():
	enemy_died.emit()
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		die()


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		monitor_player_position = true


func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		monitor_player_position = false


func _on_player_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attacking = true


func _on_player_attack_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		attacking = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "block":
		$Timer.start()
		on_cooldown = true


func _on_timer_timeout() -> void:
	on_cooldown = false
