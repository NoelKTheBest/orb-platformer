extends BasicEntity

const KICK_ANIMATION_NAME = "Assassin_Anims/kicked"
const DODGE_ANIMATION_NAME = "Assassin_Anims/dodge"


func _ready() -> void:
	super()
	debug = true
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	$AnimationTree.animation_started.connect(func(anim_name: StringName): print(anim_name, " started"))
	
	monitor_player_position = true


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	#print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	check_for_kickbox(area)
	
	if area.name == "RaycastArea":
		area.queue_free()
		die()


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	if body.is_in_group("Orbs") and !body.has_bullet_hit_anything:
		dodge_orb = true


func animation_finished(anim_name: StringName):
	print(anim_name)
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
	elif anim_name == DODGE_ANIMATION_NAME:
		dodge_orb = false
