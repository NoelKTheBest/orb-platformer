@abstract extends NavigatableEntity
## Base abstract class for tying physics and state together for all combat entities

## Determines whether or not the sprite has been flipped due to negative velocity
var is_sprite_flipped := false
var hitbox_init_pos : Vector2
## Current scale to apply to sprite2D node and other nodes that point to a specific direction
var flip_scale = -1
## Determines whether a player is nearby. Must be used with AnimationTree StateMachine Node
var player_nearby := false
## Determines whether the entity was kicked by the player
var kicked_by_player := false
## Variable for the currently playing animation from the AnimationTree node
var current_animation : String


## Adds to base implementation in ControlledEntity and also forces [b]is_sprite_flipped[/b] to false
func _ready() -> void:
	super()
	
	#set_sprite_flip_h()
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
	super(delta)
	
	# Call function to update player_nearby and other states
	update_state()


## Function to override when changing any state variables for the entity
@abstract func update_state()


## Use to update scale and/or position for optional custom nodes such as VisibilityArea
func update_node_scale():
	pass


#@abstract func set_sprite_flip_h()
