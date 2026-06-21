extends BasicEntity

const KICK_ANIMATION_NAME = "Assassin_Anims/kicked"

#@onready var guard_area: Area2D = $GuardArea
#@onready var visibility_area: Area2D = $VisibilityArea


func _ready() -> void:
	super()
	debug = true
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	$Hurtbox.area_entered.connect(area_entered_hurtbox)
	$Hurtbox.body_entered.connect(body_entered_hurtbox)
	
	monitor_player_position = true


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	#print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	if area.is_in_group("Physical Attacks"):
		if area.name == "KickHitbox":
			kicked_by_player = true
		#elif area.name == "Kickbox" and !kicked_by_player:
			#dominoed = true
	


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	pass


func animation_finished(anim_name: StringName):
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
