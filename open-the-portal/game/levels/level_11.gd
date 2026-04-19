extends Node


## Used to calculate how often secondary enemy types are spawned. The higher the number, the less frequently secondary enemies spawn
@export var enemy_2_mod: int = 3
@export var total_number_of_enemies: int = 15
## Number of enemies to be spawned at spawn points
@export var spawn_point_enemy_count: int = 2
## Determines how close player should be before an enemy spawn there
@export var spawn_point_range = 150

var total_enemies_spawned
var num_enemy_left
var spawn_point_rate
var enemy_2_mod_rem
var player_is_ready = false
var player_is_dead = false
var enemy_scene = preload("res://game/scenes/basic_enemy.tscn")
var assassin = preload("res://prototype_2/assassin.tscn")
var player
var sp_toggle = 0
var controller_is_dead = false

# Spawn Points
@onready var spawn_point_1: Sprite2D = $SpawnPoint1
@onready var spawn_point_2: Sprite2D = $SpawnPoint2
@onready var spawn_point_3: Sprite2D = $SpawnPoint3
@onready var spawn_point_4: Sprite2D = $SpawnPoint4
@onready var spawn_point_5: Sprite2D = $SpawnPoint5
@onready var start_enemy_spawn_timer: Timer = $StartEnemySpawnTimer
var spawn_points = []
var spawn_points_U = []
var spawn_points_B = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Door.show_label = true
	$Door2.show_label = true
	player = $Player
	$Player/UserInterface/Node.game_ticks = 16
	spawn_points = [spawn_point_1, spawn_point_2, spawn_point_3, spawn_point_4, spawn_point_5]
	spawn_points_U = [spawn_point_1, spawn_point_2, spawn_point_3]
	spawn_points_B = [spawn_point_4, spawn_point_5]
	
	total_number_of_enemies += spawn_point_enemy_count
	total_enemies_spawned = get_tree().get_nodes_in_group("Enemy").size()
	num_enemy_left = total_number_of_enemies - total_enemies_spawned
	print("enemies left: ", num_enemy_left)
	#print("total_enemies_spawned % total_number_of_enemy_2: ", total_enemies_spawned % enemy_2_mod)
	@warning_ignore("integer_division")
	#print("total num of enemies: ", total_number_of_enemies, "; Spawn Point Rate: ",  total_number_of_enemies / spawn_point_enemy_count)
	
	# Take initial secondary enemy ratio and use it to determine secondary enemy spawn rate
	enemy_2_mod_rem = total_enemies_spawned % enemy_2_mod
	
	# Set Spawn Point Usage Rate
	@warning_ignore("integer_division")
	spawn_point_rate = (total_number_of_enemies / spawn_point_enemy_count) - 3
	#print("rem: ", 8 % spawn_point_rate, "; 2nd rem: ", 16 % spawn_point_rate, "; 3rd rem: ", 12 % spawn_point_rate)
	print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Door.player_can_use_door and Input.is_action_just_pressed("use_door"):
		$Player.position = $Door2.position
	if $Door2.player_can_use_door and Input.is_action_just_pressed("use_door"):
		$Player.position = $Door.position
	
	if player_is_ready and !player_is_dead:
		var enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			enemy.monitor_player_position = true
			enemy.player_position = player.position
			enemy.walking = false
	
	if !controller_is_dead:
		$ForcefieldController.monitor_player_position = true
		if !player_is_dead: $ForcefieldController.player_position = player.position
		$ForcefieldController.number_of_enemies = get_tree().get_nodes_in_group("Enemy").size()
		$ForcefieldController.return_point_x = $ReturnPoint.position.x
	else:
		if get_tree().get_nodes_in_group("Enemy").size() == 0 and $Forcefield != null: $Forcefield.queue_free()
	
	#if !player_is_dead:
		#enemy_spawn_point1 = player.position - Vector2(sp_spacing, 5)
		#enemy_spawn_point2 = player.position + Vector2(sp_spacing, -5)
		#
		#if (player.position.x - lwp.position.x) < sp_spacing:
			#var x = (player.position.x - lwp.position.x) / 2
			#enemy_spawn_point1 = Vector2(x, enemy_spawn_point1.y)
		#if (rwp.position.x - player.position.x) < sp_spacing:
			#var x = (rwp.position.x - player.position.x) / 2 + player.position.x
			#enemy_spawn_point2 = Vector2(x, enemy_spawn_point2.y)
		#sprite1.position.x = enemy_spawn_point1.x
		#sprite2.position.x = enemy_spawn_point2.x


func _on_start_enemy_spawn_timer_timeout() -> void:
	$EnemySpawnInterval.start()


func _on_enemy_spawn_interval_timeout() -> void:
	if total_enemies_spawned != total_number_of_enemies:
		var new_enemy
		# Continuously check to see if a mod operation returns a remainder that matches the initial secondary enemy ratio
		if total_enemies_spawned % enemy_2_mod == enemy_2_mod_rem:
			new_enemy = assassin.instantiate()
		else:
			new_enemy = enemy_scene.instantiate()
		
		var _spawn_point_rem = total_enemies_spawned % spawn_point_rate
		var use_spawn_point = false
		#var player_is_close = false
		#if (total_enemies_spawned % spawn_point_rate == 0): 
		use_spawn_point = true
		
		if !player_is_dead and use_spawn_point:
			var min_dist = 10000
			var closest_point
			
			if $UpperFloorArea.has_overlapping_bodies():
				for sp in spawn_points_U:
					var dist = abs(player.position.x - sp.position.x)
					if dist < spawn_point_range and dist < min_dist:
						min_dist = dist
						closest_point = sp
			elif !$UpperFloorArea.has_overlapping_bodies():
				for sp in spawn_points_B:
					var dist = abs(player.position.x - sp.position.x)
					if dist < spawn_point_range and dist < min_dist:
						min_dist = dist
						closest_point = sp
			
			add_child(new_enemy)
			new_enemy.position = closest_point.position
		
		#if !player_is_dead and !player_is_close:
			#match sp_toggle:
				#0:
					#add_child(new_enemy)
					#new_enemy.position = sprite1.position
					#sp_toggle = 1 - sp_toggle
				#1:
					#add_child(new_enemy)
					#new_enemy.position = sprite2.position
					#sp_toggle = 1 - sp_toggle
		
		if total_enemies_spawned < total_number_of_enemies: 
			total_enemies_spawned += 1
			$EnemySpawnInterval.start()
			num_enemy_left = total_number_of_enemies - total_enemies_spawned
			print("Enemies left: ", num_enemy_left)
		else:
			pass


func _on_player_player_is_ready() -> void:
	player_is_ready = true
	start_enemy_spawn_timer.start()


func _on_game_over_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_player_player_died() -> void:
	player_is_dead = true
	$Player.queue_free()
	#game_over = true
	$GameOverTimer.start()
