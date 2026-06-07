@abstract extends NavigatableEntity

var is_sprite_flipped := false
var hitbox_init_pos : Vector2
var flip_scale = -1
## Determines whether a player is nearby. Must be used with AnimationTree StateMachine Node
var player_nearby := false


func _process(_delta: float) -> void:
	if velocity.x < 0: 
		is_sprite_flipped = true
		#$Hitbox.position = Vector2(-18, 3)
		#if $VisibilityArea: $VisibilityArea.scale.x = -1
	elif velocity.x > 0: 
		is_sprite_flipped = false
		#$Hitbox.position = Vector2(18, 3)
		#if $VisibilityArea: $VisibilityArea.scale.x = 1


func _physics_process(delta: float) -> void:
	super(delta)
	
	# Call function to update player_nearby and other states
	update_state()


## Function to override when changing any state variables for the entity
@abstract func update_state()
