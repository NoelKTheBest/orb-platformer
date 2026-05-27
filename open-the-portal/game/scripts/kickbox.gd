extends Area2D

# Define vector for movement
@export var knockback: Vector2

# Animate Vector using an AnimationPlayer node
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	queue_free()
