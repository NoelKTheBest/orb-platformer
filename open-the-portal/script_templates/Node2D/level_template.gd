# meta-description: Predefined setup for level scripts
# meta-default: true
# meta-space-indent: 4

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
var player_is_dead = false

# Spawn Points
@onready var spawn_point_1: Sprite2D = $SpawnPoint1
@onready var spawn_point_2: Sprite2D = $SpawnPoint2
@onready var spawn_point_3: Sprite2D = $SpawnPoint3
@onready var spawn_point_4: Sprite2D = $SpawnPoint4
@onready var spawn_point_5: Sprite2D = $SpawnPoint5
#@onready var start_enemy_spawn_timer: Timer = $StartEnemySpawnTimer
var spawn_points = []
var spawn_points_U = []
var spawn_points_B = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_points = [spawn_point_1, spawn_point_2, spawn_point_3, spawn_point_4, spawn_point_5]
	#spawn_points_U = [spawn_point_1, spawn_point_2, spawn_point_3]
	#spawn_points_B = [spawn_point_4, spawn_point_5]
	
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
func _process(delta: float) -> void:
	pass


func _on_enemy_spawn_interval_timeout() -> void:
	if total_enemies_spawned != total_number_of_enemies:
		var new_enemy
		# Continuously check to see if a mod operation returns a remainder that matches the initial secondary enemy ratio
		if total_enemies_spawned % enemy_2_mod == enemy_2_mod_rem:
			#new_enemy = assassin.instantiate()
			pass
		else:
			#new_enemy = enemy_scene.instantiate()
			pass
		
		var _spawn_point_rem = total_enemies_spawned % spawn_point_rate
		var use_spawn_point = false
		#var player_is_close = false
		#if (total_enemies_spawned % spawn_point_rate == 0): 
		use_spawn_point = true
		
		if !player_is_dead and use_spawn_point:
			var max_dist = 0
			var closest_point
			
			if $UpperFloorArea.has_overlapping_bodies():
				for sp in spawn_points_U:
					var dist
					#var dist = abs(player.position.x - sp.position.x)
					if dist > max_dist:
						max_dist = dist
						closest_point = sp
			elif !$UpperFloorArea.has_overlapping_bodies():
				for sp in spawn_points_B:
					var dist
					#var dist = abs(player.position.x - sp.position.x)
					if dist > max_dist:
						max_dist = dist
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
