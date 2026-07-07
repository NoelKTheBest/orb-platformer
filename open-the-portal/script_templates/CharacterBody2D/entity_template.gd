# meta-description: Predefined setup for combat entities including basic state, navigation, and movement
# meta-default: true
# meta-space-indent: 4

extends BasicEntity

const KICK_ANIMATION_NAME = "kicked"


func _ready() -> void:
	super()
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	
	monitor_player_position = true


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
