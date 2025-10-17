extends CharacterBody2D

@onready var orb_spawn_position: Node2D = $OrbSpawnPosition
@onready var sprite_2d: Sprite2D = $Sprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ORB_VELOCITY = 500

var orb = preload("res://scenes/orb.tscn")
var aim_with_move_keys: bool = false
#var aim_dir
var y_slow: float = 1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("fire"):
		var new_orb = orb.instantiate()
		
		# Set properties before node is ready to have access to them
		new_orb.position = orb_spawn_position.position
		new_orb.linear_v = aim_orb()
		add_child(new_orb)
	
	if Input.is_action_just_pressed("change_controls"):
		aim_with_move_keys = !aim_with_move_keys
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		if is_on_floor(): $AnimationPlayer.play("Player_Movement/run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor(): $AnimationPlayer.play("Player_Movement/idle")
	
	if direction < 0: sprite_2d.flip_h = true 
	elif direction > 0: sprite_2d.flip_h = false
	
	if velocity.y == JUMP_VELOCITY: $AnimationPlayer.play("Player_Movement/jump")
	if velocity.y > 0: $AnimationPlayer.play("Player_Movement/fall")

	move_and_slide()


func aim_orb():
	if aim_with_move_keys:
		# Get up key value and apply y velocity multiplier
		pass
	else:
		# Get arrow key axes and shoot
		# Optionally apply y_slow
		var vertical_axis = Input.get_axis("aim_up", "aim_down")
		var horizontal_axis = Input.get_axis("aim_left", "aim_right")
		if !horizontal_axis and !vertical_axis:
			horizontal_axis = 1 if sprite_2d.flip_h == false else -1
		var aim_dir = Vector2(horizontal_axis, vertical_axis)
		aim_dir = aim_dir.normalized() * ORB_VELOCITY
		return aim_dir
