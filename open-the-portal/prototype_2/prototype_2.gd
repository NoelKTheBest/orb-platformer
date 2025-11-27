extends Node2D

@onready var enemy_spawn_point: Node2D = $EnemySpawnPoint
@onready var enemy_spawn_point_2: Node2D = $EnemySpawnPoint2
@onready var enemy_spawn_point_3: Node2D = $EnemySpawnPoint3
@onready var enemy_spawn_point_4: Node2D = $EnemySpawnPoint4
@onready var enemy_spawn_point_5: Node2D = $EnemySpawnPoint5
@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer

var enemy_scene = preload("res://prototype_2/prototype_2_enemy.tscn")
var enemies_on_screen
var enemies_affected_by_anti_g = []
var enemy_spawn_points = []
var espi : int = 0
var spawn_toggle = 0
var player_is_ready = false
var player_is_dead = false
#var delta_total_time : float = 0.0
var total_number_of_enemies = 15
var total_enemies_spawned


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_enemies_spawned = get_tree().get_nodes_in_group("Enemy").size()
	enemy_spawn_points = [enemy_spawn_point, enemy_spawn_point_2, enemy_spawn_point_3, enemy_spawn_point_4, enemy_spawn_point_5]
	#for spawn_point in enemy_spawn_points:
		#spawn_point.connect("countdown_finished", spawn_enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies_on_screen = get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible)
	print(enemies_on_screen)
	if player_is_ready and !player_is_dead:
		#print("hello from the player")
		for enemy in enemies_on_screen:
			enemy.player_position = $Player.position


func enemy_is_visible(enemy):
	if enemy.visible_on_screen_notifier_2d.is_on_screen(): return enemy


#func spawn_enemy():
	#var new_enemy = enemy_scene.instantiate()
	#enemy_spawn_points[espi].add_child(new_enemy)
	#espi += 1
	#if espi > enemy_spawn_points.size() - 1:
		#espi = 0
	#
	#enemy_spawn_points[espi].play_countdown_timer()


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
	$EnemySpawnInterval.start()


func _on_player_player_died() -> void:
	player_is_dead = true
	$Player.queue_free()
	#game_over = true
	$GameOverTimer.start()


func _on_game_over_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_player_player_is_ready() -> void:
	player_is_ready = true
	enemy_spawn_timer.start()


func _on_enemy_spawn_interval_timeout() -> void:
	var small = 100000000000000
	var i = 0
	for spawn_point in enemy_spawn_points:
		if spawn_point.position.distance_to($Player.position) < small:
			small = spawn_point.position.distance_to($Player.position)
			espi = i
			i += 1
		
	enemy_spawn_points[espi].play_countdown_timer()
	if total_enemies_spawned < 15: 
		total_enemies_spawned += 1
		$EnemySpawnInterval.start()
	else:
		pass
