extends BasicEntity

const KICK_ANIMATION_NAME = "kicked"

@onready var orb_spawn_position = $Sprite2D/Marker2D
var orb = preload("res://game/scenes/enemy_orb.tscn")
const ORB_VELOCITY = 475
var shoot_interval = 1.5
var shoot_timer : Timer

#This is the changes that i made, you can discard it if you don't like it 
var shoot_range = 200.0
var post_delay = 0.3
enum gunnerstate {Guard, Shoot_Cooldown, Flee}
var gunner_state : gunnerstate = gunnerstate.Guard
var player_dist_shot: float
var post_shot_timer: Timer

func _ready() -> void:
	super()
	debug = true
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	$Hurtbox.area_entered.connect(area_entered_hurtbox)
	$Hurtbox.body_entered.connect(body_entered_hurtbox)
	
	monitor_player_position = true
	shoot_timer = Timer.new()
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(shoot_timer_timeout)
	add_child(shoot_timer)
	post_shot_timer = Timer.new()
	post_shot_timer.one_shot = true
	post_shot_timer.timeout.connect(post_timer_timeout)
	add_child(post_shot_timer)


func _process(_delta: float) -> void:
	super(_delta)
	always_face_player()
	var dist = abs(SceneVariables.player_position.x - position.x)
	match gunner_state:
		gunnerstate.Guard: 
			on_guard = true
			if dist < shoot_range:
				on_guard = false
				gunner_state = gunnerstate.Shoot_Cooldown
		gunnerstate.Shoot_Cooldown:
			if dist >= shoot_range:
				gunner_state = gunnerstate.Guard
			elif shoot_timer.is_stopped():
				shoot_timer_timeout()
				shoot_timer.start(shoot_interval)
				player_dist_shot = dist
				post_shot_timer.start(post_delay)
		gunnerstate.Flee:
			on_guard = false
			if dist < shoot_range or is_on_wall():
				gunner_state = gunnerstate.Shoot_Cooldown

func _physics_process(delta: float) -> void:
	super(delta)
	if gunner_state == gunnerstate.Flee:
		var toward_player = sign(SceneVariables.player_position.x - position.x)
		velocity.x = -toward_player * speed


func shoot_timer_timeout():
	var new_orb = orb.instantiate()
	# Set properties before node is ready to have access to them
	orb_spawn_position.position.x = -22 if sprite_2d.flip_h else 22
	new_orb.global_position = orb_spawn_position.global_position
	var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
	new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY
	get_tree().current_scene.add_child(new_orb)
	SfxSpawner.set_player(orb_spawn_position.global_position, 17)

func post_timer_timeout():
	var dist_now = abs(SceneVariables.player_position.x - position.x)
	if dist_now < player_dist_shot:
		gunner_state = gunnerstate.Flee
	else:
		gunner_state = gunnerstate.Guard

@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	#print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	if area.is_in_group("Physical Attacks"):
		if area.name == "KickHitbox":
			kicked_by_player = true
			#print("KICKED HARD", name)
		#elif area.name == "Kickbox" and !kicked_by_player:
			#dominoed = trued
			#print("DOMINOED HARD", name)


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	pass


func animation_finished(anim_name: StringName):
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
		kick_force = 600

func always_face_player():
	sprite_2d.flip_h = SceneVariables.player_position.x < position.x 
