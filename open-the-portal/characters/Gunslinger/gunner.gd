extends BasicEntity

var i := 0

@export var gun_ammo_count = 3


func _ready() -> void:
	super()
	
	$AnimationTree.active = true
	monitor_player_position = true
	print(4)


func update_state():
	print(velocity.x, "; ", speed, "; ", get_target_position().x)
	$Sprite2D.flip_h = is_sprite_flipped


func set_target_position():
	pass


func update_node_scale():
	pass


func set_sprite_flip_h():
	#$Sprite2D.flip_h = false
	pass
