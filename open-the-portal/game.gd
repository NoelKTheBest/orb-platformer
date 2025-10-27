extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	pass


func _on_character_body_2d_2_enemy_on_screen(enemy_position: Vector2) -> void:
	print(enemy_position)
	# We need to update this position when the enemy moves 
	$CharacterBody2D.enemy_pos = enemy_position
