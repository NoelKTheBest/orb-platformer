extends Node2D

@onready var enemy_spawn_location_1: Node2D = $Player/EnemySpawnLocation1
@onready var enemy_spawn_location_2: Node2D = $Player/EnemySpawnLocation2

var enemy_scene = preload("res://prototype_2/prototype_2_enemy.tscn")
var enemies_on_screen
var enemies_affected_by_anti_g = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies_on_screen = get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible)


func enemy_is_visible(enemy):
	if enemy.visible_on_screen_notifier_2d.is_on_screen(): return enemy


func _on_player_anti_gravity_zone_created() -> void:
	for enemy in enemies_on_screen:
		enemy.player_position = $Player.position
		enemy.launch()
		enemies_affected_by_anti_g.append(enemy)
	#print(enemies)
	$ZeroGravityZoneTimer.start()


func _on_zero_gravity_zone_timer_timeout() -> void:
	for enemy in enemies_affected_by_anti_g:
		enemy.in_anti_gravity_zone = false
	
	$Player.in_anti_gravity_zone = false
	enemies_affected_by_anti_g = []


func _on_enemy_spawn_timer_timeout() -> void:
	var new_enemy = enemy_scene.instantiate()
	#new_enemy.position = to_global(enemy_spawn_location_1.position)
	#enemy_spawn_location_1.add_child(new_enemy)
	add_child(new_enemy)
	print(new_enemy, new_enemy.position)
	print(enemy_spawn_location_1, enemy_spawn_location_1.position)
