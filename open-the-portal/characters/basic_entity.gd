@abstract extends NavigatableEntity
## Base abstract class for tying physics and state together for all combat entities

const KICK_AREA_NAME = "Kickbox"


## Signal sent when the entity wishes to call for backup
signal call_for_reinforcements

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
var dodge_orb: bool
## Determines if the player's kick hitbox is detected
var player_about_to_kick
## Variable for the currently playing animation from the AnimationTree node
var current_animation : String
## Determines if the enemy is currently facing the player
var facing_player : bool
## Reference to a scene tree timer
var kick_timer
var domino_timer

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


## Adds to base implementation in ControlledEntity and also forces [b]is_sprite_flipped[/b] to false
func _ready() -> void:
	super()
	
	print(3)


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
	
	#if kicked_by_player and has_child(KICK_AREA_NAME):
		
	
	# Call function to update player_nearby and other states
	update_state()
	update_velocity()
	move_and_slide()


func is_facing_player():
	if player_position.x > position.x and SceneVariables.player_facing_left and !is_sprite_flipped:
		facing_player = true
	elif player_position.x < position.x and !SceneVariables.player_facing_left and is_sprite_flipped:
		facing_player = true
	# If none of the above conditions are true, set to false
	else:
		facing_player = false


## Freeze the x movement of an entity...
func set_speed():
	# If an entity is going to dodge an attack
	#if dodge_orb:
		#speed = 0
	# If an entity is going to attack the player
	#elif player_nearby:
		#speed = 0
	pass


## Function to override when changing any state variables for the entity
@abstract func update_state()


## Function to override when state must change velocity
func update_velocity():
	if kicked_by_player and has_child(KICK_AREA_NAME):
		# First frame of kick
		if kick_timer == null:
			kick_timer = get_tree().create_timer(kick_deceleration_time)
			remaining_kick_force = kick_force - kick_force_resistance
		
		if kick_timer.time_left > 0:
			remaining_kick_force -= kick_deceleration
		
		velocity.x = remaining_kick_force * 1 if player_position.x < position.x else remaining_kick_force * -1
	elif dominoed:
		# First frame of domino effect
		if domino_timer == null:
			domino_timer = get_tree().create_timer(domino_deceleration_time)
			remaining_domino_effect_force = domino_force - domino_force_resistance
		
		if domino_timer.time_left > 0:
			remaining_domino_effect_force -= domino_deceleration
		velocity.x = remaining_domino_effect_force * 1 if player_position.x < position.x else remaining_domino_effect_force * -1


## Use to update scale and/or position for optional custom nodes such as VisibilityArea
func update_node_scale():
	collision_shape_2d.position.x = collider_init_pos.x * -1 if is_sprite_flipped else collider_init_pos.x * 1


@abstract func area_entered_hurtbox(area: Area2D)


@abstract func body_entered_hurtbox(body: Node2D)
