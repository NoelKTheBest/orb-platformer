extends CharacterBody2D

signal enemy_on_screen()

var monitor_player_position
var player_position
## Distance from the player where enemy starts attacking
@export var attack_distance : int = 30
@export var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !$AnimationPlayer.is_playing(): $AnimationPlayer.play("idle")
	if velocity.x < 0: $Sprite2D.flip_h = true
	elif velocity.x > 0: $Sprite2D.flip_h = false


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if monitor_player_position:
		var direction
		var target_position = (player_position - position).normalized()
		var distance_to = position.distance_squared_to(player_position)
		
		velocity.x = target_position.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# We need a better way to detect the player's direction relative to the enemy
	# Copy code from warrior script in wombo combo
	if velocity.x != 0:
		$AnimationPlayer.play("run")
	elif velocity.x == 0:
		$AnimationPlayer.play("idle")
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("an orb is close")
	$AnimationPlayer.stop()
	$AnimationPlayer.play("block")


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		die()


func die():
	queue_free()


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		monitor_player_position = true


func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		monitor_player_position = false


func _on_player_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$AnimationPlayer.play("block")
