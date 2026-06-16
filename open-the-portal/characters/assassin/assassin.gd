extends BasicEntity

const KICK_ANIMATION_NAME = "Assassin_Anims/kicked"
const BDA_NAME = "BulletDetectionArea"
const GA_NAME = "GuardArea"
const VA_NAME = "VisibilityArea"

var player_within_vicinity

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_attack_area: Area2D = $PlayerAttackArea
#@onready var guard_area: Area2D = $GuardArea
#@onready var visibility_area: Area2D = $VisibilityArea


func _ready() -> void:
	super()
	
	# Uncomment this line when the scene has the node mentioned below
	#collider_init_pos = collision_shape_2d.position
	
	$AnimationTree.active = true
	$Hurtbox.area_entered.connect(area_entered_hurtbox)
	$Hurtbox.body_entered.connect(body_entered_hurtbox)
	
	monitor_player_position = true


func update_state():
	#print(velocity.x, "; ", speed, "; ", get_target_position().x)
	
	# This is used to transition to attack state if player is close enough
	player_nearby = true if player_attack_area.has_overlapping_bodies() else false
	if has_child(BDA_NAME):
		bullet_nearby = true if $BulletDetectionArea.has_overlapping_bodies() else false
	if has_child(GA_NAME):
		player_within_vicinity = true if $GuardArea.has_overlapping_bodies() else false
	if has_child(VA_NAME):
		player_within_vicinity = true if $VisibilityArea.has_overlapping_bodies() else false
	
	if initially_guarding:
		if player_nearby or bullet_nearby:
			on_guard = false
			call_for_reinforcements.emit() # Called whenever guard state changes. parent can ignore if needed
		if !player_nearby and !bullet_nearby: on_guard = true
	
	if initially_patrolling:
		if player_nearby or player_within_vicinity:
			on_patrol = false
			call_for_reinforcements.emit() # Called whenever patrol state changes. parent can ignore if needed
	
	if kicked_by_player: set_collision_mask_value(2, true)
	else: set_collision_mask_value(2, false)
	
	$Sprite2D.flip_h = is_sprite_flipped


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	if area.is_in_group("Physical Attacks"):
		if area.name == "KickHitbox":
			kicked_by_player = true
		elif area.name == "Kickbox":
			dominoed = true
	


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	pass


func animation_finished(anim_name: StringName):
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
