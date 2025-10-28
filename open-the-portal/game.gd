extends Node2D

@onready var player: CharacterBody2D = $Player

var monitor_enemies : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if monitor_enemies: player.enemy_pos = $Enemy.position
	$Enemy.player_position = player.position


func _on_enemy_enemy_on_screen() -> void:
	monitor_enemies = true


func position_debug():
	var a = str(player.position)
	var b = str($Enemy.position)
	var c = str($Enemy.player_position)
	var formatted_string: String = a + 'n/' + b + 'n/' + c + 'n/'
	return formatted_string
