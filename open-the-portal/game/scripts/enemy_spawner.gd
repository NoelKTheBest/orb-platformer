@tool
extends Node2D

@export var reset_position: Vector2
## This list of IDs is used to spawn in new enemies, the list will be cycled through
## and the first enemies in the list will spawn at the first spawn points
@export var on_death_spawns = []
# ID List
# 0 - Mercenary
# 1 - Assassin
# 2 - Gunner

var mercenary_scene = preload("res://game/scenes/basic_enemy.tscn")
var assassin_scene = preload("res://game/scenes/assassin.tscn")
var gunner_scene = preload("res://characters/Gunslinger/gunner.tscn")
var enemy_label_scene = preload("res://game/scenes/enemy_placement_label.tscn")
var enemy_placements = []
var num_placements: int
var enable_spawn_interval: bool
var spawn_points = []



#@export var on_death_enemy_placements = [["Mercenary"],[Vector2(0, 0)]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Player".player_died.connect(_on_player_died)
	spawn_points = get_tree().get_nodes_in_group("Spawn Point")
	#get_spawn_points_in_floor()
	
	for i in num_placements:
		enemy_placements.append(enemy_label_scene.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		if GameState.player_flicked_switch and GameState.flick_switch_1():
			start_spawn_interval()
			GameState.player_flicked_switch = false
		
		var current_floor = GameState.player_current_room.x
		#get_spawn_points_in_floor(current_floor)
	else:
		print(delta)
		


func _draw() -> void:
	if Engine.is_editor_hint():
		var default_font = ThemeDB.fallback_font
		var default_font_size = ThemeDB.fallback_font_size
		draw_string(default_font, Vector2(6, 4), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)


func get_spawn_points_in_floor(curr_floor: int):
	var curr_floor_spawns = []
	for sp in spawn_points:
		if sp.floor_number == curr_floor:
			curr_floor_spawns.append(sp)
	
	return curr_floor_spawns


func start_spawn_interval():
	$EnemySpawnInterval.start()


func _on_enemy_spawn_interval_timeout() -> void:
	pass # Replace with function body.


func _on_player_died() -> void:
	# Reset player position to middle of screen
	$"../Player".position = reset_position
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	
	var floor_spawn_positions = get_spawn_points_in_floor(GameState.player_current_room.x)
	
	var i = 0
	for id in on_death_spawns:
		var new_enemy
		match id:
			0:
				new_enemy = mercenary_scene.instantiate()
			1:
				new_enemy = assassin_scene.instantiate()
			2:
				new_enemy = gunner_scene.instantiate()
		
		new_enemy.position = floor_spawn_positions[i].position
		add_child(new_enemy)
		i += 1
