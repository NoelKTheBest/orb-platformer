# meta-description: Predefined setup for combat entities including basic state, navigation, and movement
# meta-default: true
# meta-space-indent: 4

extends BasicEntity

const KICK_ANIMATION_NAME = "kicked"


func _ready() -> void:
	super()
	
	# Uncomment this line when the scene has the node mentioned below
	#collider_init_pos = collision_shape_2d.position
	
	$AnimationTree.active = true
	$Hurtbox.area_entered.connect(area_entered_hurtbox)
	$Hurtbox.body_entered.connect(body_entered_hurtbox)
	
	monitor_player_position = true


func update_state():
	print(velocity.x, "; ", speed, "; ", get_target_position().x)
	
	$Sprite2D.flip_h = is_sprite_flipped
	
	if kicked_by_player and $Kickbox: velocity.x = $Kickbox.knockback.x * 1 if player_position.x < position.x else $Kickbox.knockback.x * -1


func set_target_position():
	pass


func update_node_scale():
	# Uncomment this line when the scene has the node mentioned below
	#collision_shape_2d.position.x = collider_init_pos.x * -1 if is_sprite_flipped else collider_init_pos.x * 1
	pass


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	if area.is_in_group("Physical Attacks"):
		kicked_by_player = true


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	pass


func animation_finished(anim_name: StringName):
	if anim_name == KICK_ANIMATION_NAME:
		kicked_by_player = false
