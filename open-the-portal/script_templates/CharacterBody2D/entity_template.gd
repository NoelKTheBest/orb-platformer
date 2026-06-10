# meta-description: Predefined setup for combat entities including basic state, navigation, and movement
# meta-default: true
# meta-space-indent: 4

extends BasicEntity

func _ready() -> void:
	super()
	
	$AnimationTree.active = true
	monitor_player_position = true


func update_state():
	print(velocity.x, "; ", speed, "; ", get_target_position().x)
	
	$Sprite2D.flip_h = is_sprite_flipped


func set_target_position():
	pass


func update_node_scale():
	pass
