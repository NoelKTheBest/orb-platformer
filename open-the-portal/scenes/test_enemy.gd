extends CharacterBody2D

signal enemy_on_screen(enemy_position : Vector2)

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


func _physics_process(delta: float) -> void:
	var target_position = (player_position - position)
	var distance_to = position.distance_squared_to(player_position)
	
	velocity.x = target_position.x * speed
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("an orb is close")
	$AnimationPlayer.stop()
	$AnimationPlayer.play("block")


func get_player_position(player_pos : Vector2):
	player_position = player_pos


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	enemy_on_screen.emit(position)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("Orbs"):
		die()


func die():
	queue_free()


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_position = body.position


func _on_player_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_position = position


func _on_player_attack_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$AnimationPlayer.play("block")
