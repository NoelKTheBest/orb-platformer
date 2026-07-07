extends BasicEntity

const KICK_ANIMATION_NAME = "kicked"

var orb_spawn_position
var orb = preload("res://game/scenes/enemy_orb.tscn")
const ORB_VELOCITY = 475


func _ready() -> void:
	super()
	debug = true
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	
	monitor_player_position = true


func _process(_delta: float) -> void:
	super(_delta)
	
	if player_nearby:
		var new_orb = orb.instantiate()
		
		# Set properties before node is ready to have access to them
		orb_spawn_position.position.x = -22 if sprite_2d.flip_h else 22
		new_orb.position = orb_spawn_position.position
		var aim_dir = Vector2(1, 0) if sprite_2d.flip_h == false else Vector2(-1, 0)
		new_orb.linear_v = aim_dir.normalized() * ORB_VELOCITY
		add_child(new_orb)
		SfxSpawner.set_player(orb_spawn_position, 17)


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	#print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	check_for_kickbox(area)


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	pass


func animation_finished(anim_name: StringName):
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
		kick_force = 600
