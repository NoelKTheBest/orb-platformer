extends BasicEntity

const KICK_ANIMATION_NAME = "kicked"
const ORB_VELOCITY = 475

var orb = preload("res://game/scenes/enemy_orb.tscn")
var cooldown_active
var can_shoot_orb: bool

@onready var orb_spawn_position: Node2D = $OrbSpawnPosition


func _ready() -> void:
	super()
	debug = true
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	
	monitor_player_position = true


func _process(_delta: float) -> void:
	super(_delta)
	
	if !kicked_by_player:
		if player_nearby and !cooldown_active:
			can_shoot_orb = true
			attacking = true
	# Comment out the below to make the gunner shoot a revenge shot for getting kicked
	else:
		can_shoot_orb = false
		attacking = false


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	#print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	check_for_kickbox(area)


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	print(body)


func animation_finished(anim_name: StringName):
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
		kick_force = 600


func _on_shoot_timer_timeout() -> void:
	cooldown_active = false


func shoot_orb():
	var new_orb = orb.instantiate()
		
	# Set properties before node is ready to have access to them
	orb_spawn_position.position.x = -22 if is_sprite_flipped else 22
	new_orb.position = orb_spawn_position.position
	var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
	new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY
	add_child(new_orb)
	SfxSpawner.set_player(orb_spawn_position.position, 17)
	$ShootTimer.start()
	cooldown_active = true


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "shoot":
		can_shoot_orb = false
		attacking = false
