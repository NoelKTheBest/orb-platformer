extends BasicEntity

const KICK_ANIMATION_NAME = "kicked"
const BDA_NAME = "BulletDetectionArea"
const GA_NAME = "GuardArea"
const VA_NAME = "VisibilityArea"

var player_within_vicinity

var orb_spawn_position
var orb = preload("res://game/scenes/enemy_orb.tscn")
const ORB_VELOCITY = 475

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_attack_area: Area2D = $PlayerAttackArea


func _ready() -> void:
	super()
	
	collider_init_pos = collision_shape_2d.position
	
	$AnimationTree.active = true
	$AnimationTree.animation_finished.connect(animation_finished)
	$Hurtbox.area_entered.connect(area_entered_hurtbox)
	$Hurtbox.body_entered.connect(body_entered_hurtbox)
	
	monitor_player_position = true
	print(4)


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


func update_state():
	#print(velocity.x, "; ", speed, "; ", get_target_position().x)
	
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


func update_velocity():
	if kicked_by_player and $Kickbox: 
		velocity.x = $Kickbox.knockback.x * 1 if player_position.x < position.x else $Kickbox.knockback.x * -1


func update_node_scale():
	collision_shape_2d.position.x = collider_init_pos.x * -1 if is_sprite_flipped else collider_init_pos.x * 1


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
