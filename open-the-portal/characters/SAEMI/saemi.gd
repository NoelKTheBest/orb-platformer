extends CharacterBody2D


@export var speed := 200
#const JUMP_VELOCITY = -400.0

var monitor_player_position = false
var player_position = Vector2.ZERO
var hitbox_pos: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_attack_area: Area2D = $PlayerAttackArea
@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	$AnimationTree.active = true
	hitbox_pos = $Hitbox.position


func _process(_delta: float) -> void:
	if velocity.x != 0:
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
	
	
	move_and_slide()
