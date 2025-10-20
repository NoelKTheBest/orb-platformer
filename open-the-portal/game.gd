extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_character_body_2d_2_enemy_on_screen(enemy_position: Vector2) -> void:
	print(enemy_position)
	$CharacterBody2D.enemy_pos = enemy_position
