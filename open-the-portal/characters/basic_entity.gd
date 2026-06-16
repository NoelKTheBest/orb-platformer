@abstract extends NavigatableEntity
## Base abstract class for tying physics and state together for all combat entities

const KICK_AREA_NAME = "Kickbox"
const BDA_NAME = "BulletDetectionArea"
const GA_NAME = "GuardArea"
const VA_NAME = "VisibilityArea"

## Signal sent when the entity wishes to call for backup
signal call_for_reinforcements

## Determines if the entity is currently attacking
@export var attacking: bool
## Determines whether the entity should dodge and oncoming attack
@export var dodging: bool

## Determines whether or not the sprite has been flipped due to negative velocity
var is_sprite_flipped := false
## Current scale to apply to sprite2D node and other nodes that point to a specific direction
var flip_scale = -1
## Determines whether a player is nearby. Must be used with AnimationTree StateMachine Node
var player_nearby := false
## Determines whether a bullet is nearby. Must be used with AnimationTree StateMachine Node
var bullet_nearby := false
## Determines whether the entity was kicked by the player
var kicked_by_player := false
## Determines whether the entity is affected by another body that was kicked by the player
var dominoed := false
## Determines whether the entity should dodge and oncoming attack
var dodge_orb := false
## Determines if the player's kick hitbox is detected
var player_about_to_kick
## Variable for the currently playing animation from the AnimationTree node
var current_animation : String
## Determines if the enemy is currently facing the player
var facing_player : bool
## Determines if the player is within the bounds of either the guard area or the visibility area
var player_within_vicinity
## Reference to a scene tree timer for when an entity is kicked
var kick_timer
## Reference to a scene tree timer for when an entity is dominoed
var domino_timer

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var player_attack_area: Area2D = $PlayerAttackArea


## Adds to base implementation in ControlledEntity and also forces [b]is_sprite_flipped[/b] to false
func _ready() -> void:
	super()
	
	collider_init_pos = collision_shape_2d.position


## Sets [b]is_sprite_flipped[/b] and [b]flip_scale[/b] based on current x velocity[br][br]
## Do [b]not[/b] override this function unless a very specific implementation is needed
func _process(_delta: float) -> void:
	if !kicked_by_player:
		if velocity.x < 0: 
			is_sprite_flipped = true
			flip_scale = -1
			#$Hitbox.position = Vector2(-18, 3)
			#if $VisibilityArea: $VisibilityArea.scale.x = -1
		elif velocity.x > 0: 
			is_sprite_flipped = false
			flip_scale = 1
			#$Hitbox.position = Vector2(18, 3)
			#if $VisibilityArea: $VisibilityArea.scale.x = 1
	
	update_node_scale()


## Adds to the base _physics_process implementation by calling state update functions and updating other physics based variables within the physics loop
func _physics_process(delta: float) -> void:
	super(delta) # on guard variable can change during this call
	
	# Find out if the entity is currently facing the player
	is_facing_player()
	#if kicked_by_player and has_child(KICK_AREA_NAME):
		
	
	# Call function to update player_nearby and other states
	update_state()
	# Update velocity if entity was kicked or dominoed
	update_velocity()
	# Change properties of node based on state
	change_properties()
	
	# if the player is currently in attack or dodge state, pause movement
	if !attacking and !dodging:
		move_and_slide()
	
	print_velocity()


## Returns true if the entity is currently facing the player, returns false otherwise
func is_facing_player():
	if player_position.x > position.x and SceneVariables.player_facing_left and !is_sprite_flipped:
		facing_player = true
	elif player_position.x < position.x and !SceneVariables.player_facing_left and is_sprite_flipped:
		facing_player = true
	# If none of the above conditions are true, set to false
	else:
		facing_player = false


## Change properties of scene based on current state
func change_properties():
	if kicked_by_player: set_collision_mask_value(2, true)
	else: set_collision_mask_value(2, false)
	
	sprite_2d.flip_h = is_sprite_flipped
	pass


## Function to override when changing any state variables for the entity
func update_state():
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


## Function to override when state must change velocity
func update_velocity():
	if kicked_by_player and has_child(KICK_AREA_NAME):
		# First frame of kick
		if kick_timer == null:
			kick_timer = get_tree().create_timer(kick_deceleration_time)
			remaining_kick_force = kick_force - kick_force_resistance
		
		if kick_timer.time_left > 0:
			remaining_kick_force -= kick_deceleration
		else:
			kick_timer = null
			kicked_by_player = false
		
		velocity.x = remaining_kick_force * 1 if player_position.x < position.x else remaining_kick_force * -1
	elif dominoed:
		# First frame of domino effect
		if domino_timer == null:
			domino_timer = get_tree().create_timer(domino_deceleration_time)
			remaining_domino_effect_force = domino_force - domino_force_resistance
		
		if domino_timer.time_left > 0:
			remaining_domino_effect_force -= domino_deceleration
		else: 
			domino_timer = null
			dominoed = false
		
		velocity.x = remaining_domino_effect_force * 1 if player_position.x < position.x else remaining_domino_effect_force * -1
		
		


## Use to update scale and/or position for optional custom nodes such as VisibilityArea
func update_node_scale():
	collision_shape_2d.position.x = collider_init_pos.x * -1 if is_sprite_flipped else collider_init_pos.x * 1


@abstract func area_entered_hurtbox(area: Area2D)


@abstract func body_entered_hurtbox(body: Node2D)
