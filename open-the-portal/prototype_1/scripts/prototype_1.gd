extends Node2D

@onready var player: CharacterBody2D = $Player

@export var enemy_compare_distance_range: float = 1.0

var monitor_enemies : bool
var enemies_in_scene
var game_over : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies_in_scene = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies_in_scene:
		enemy.connect("enemy_on_screen", enemy_is_visible)
		enemy.connect("enemy_died", enemy_is_dead)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if !game_over:
		enemies_in_scene = get_tree().get_nodes_in_group("Enemy")
		if monitor_enemies: 
			_monitor_enemies()
		else:
			player.reset_camera_follow()
		for enemy in enemies_in_scene:
			enemy.player_position = player.position
		
		#if enemies_in_scene.size() == 0:
			#pass


func _monitor_enemies() -> void:
	enemies_in_scene = get_tree().get_nodes_in_group("Enemy")
	if enemies_in_scene.size() > 1:
		player.check_surrounding_areas()
	elif enemies_in_scene.size() == 1:
		player.enemy_pos = enemies_in_scene[0].position
	elif enemies_in_scene.size() == 0:
		monitor_enemies = false
		player.enemy_pos = player.position
		


func position_debug():
	var a = str(player.position)
	var b = str($Enemy.position)
	var c = str($Enemy.player_position)
	var formatted_string: String = a + 'n/' + b + 'n/' + c + 'n/'
	return formatted_string


func enemy_is_visible():
	monitor_enemies = true


func enemy_is_dead():
	pass
	#if get_tree().get_nodes_in_group("Enemy").size() == 0:
		#monitor_enemies = false


func _on_player_player_died() -> void:
	$Timer.start()
	monitor_enemies = false
	player.queue_free()
	game_over = true


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
