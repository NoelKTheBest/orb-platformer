extends Node2D

@onready var player: CharacterBody2D = $Player

var monitor_enemies : bool
var enemies_in_scene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(get_tree().get_nodes_in_group("Enemy"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if monitor_enemies: player.enemy_pos = $Jumping_Enemy.position
	if $Jumping_Enemy: $Jumping_Enemy.player_position = player.position
	#print(get_tree().get_nodes_in_group("Enemy"))


func _on_enemy_enemy_on_screen() -> void:
	monitor_enemies = true


func position_debug():
	var a = str(player.position)
	var b = str($Enemy.position)
	var c = str($Enemy.player_position)
	var formatted_string: String = a + 'n/' + b + 'n/' + c + 'n/'
	return formatted_string


func _on_jumping_enemy_enemy_on_screen() -> void:
	pass # Replace with function body.


func enemy_is_visible():
	# 
	pass


func enemy_is_dead():
	pass
