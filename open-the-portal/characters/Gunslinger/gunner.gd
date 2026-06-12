extends BasicEntity

var i := 0

@export var gun_ammo_count = 3

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	super()
	
	collider_init_pos = collision_shape_2d.position
	
	$AnimationTree.active = true
	$Hurtbox.area_entered.connect(area_entered_hurtbox)
	$Hurtbox.body_entered.connect(body_entered_hurtbox)
	
	monitor_player_position = true
	print(4)


func update_state():
	#print(velocity.x, "; ", speed, "; ", get_target_position().x)
	
	$Sprite2D.flip_h = is_sprite_flipped


func set_target_position():
	pass


func update_node_scale():
	collision_shape_2d.position.x = collider_init_pos.x * -1 if is_sprite_flipped else collider_init_pos.x * 1


@warning_ignore("unused_parameter")
func area_entered_hurtbox(area: Area2D):
	print(area.name) # Kickbox is not visible when first being detected by the entity's hurtbox
	#kicked_by_player = true


@warning_ignore("unused_parameter")
func body_entered_hurtbox(body: Node2D):
	pass
