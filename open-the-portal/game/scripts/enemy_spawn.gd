@tool
extends Node2D

@export var enemy_types: Array[String] = ["","","","","","",""]
@export var wave_enemy_type: Array[int]
@export var wave_enemy_count: Array[int]
@export var spawn_interval : float = 1.5
@export var door_spawn : Array[NodePath]
@export var enemy_spawn_trigger : NodePath
@export var is_fighting_boss : bool
#@export var enemy_placements: Array[EnemyPlacement]
@export var epo: EnemyPlacement
@export var on_death_enemy_placements = [["Mercenary"],[Vector2(0, 0)]]

var spawn_timer : Timer
var spawn_queue : Array[int]
var spawned : int
var spawn_point : int = 0
var default_font

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	build_spawn_queue()
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(spawn_timer_timeout)
	add_child(spawn_timer)
	player.player_died.connect(respawn)
	if enemy_spawn_trigger != NodePath():
		get_node(enemy_spawn_trigger).body_entered.connect(player_entered)
	
	#default_font = ThemeDB.fallback_font




func _draw() -> void:
	if Engine.is_editor_hint():
		var default_font = ThemeDB.fallback_font
		var default_font_size = ThemeDB.fallback_font_size
		draw_string(default_font, Vector2(6, 4), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)

		
		var i = 0
		for pos in on_death_enemy_placements[1]:
			draw_string(default_font, pos, on_death_enemy_placements[0][i])
			i += 1


func build_spawn_queue():
	spawn_queue.clear()
	for i in range (len(wave_enemy_type)):
		var enemy_type = wave_enemy_type[i]
		var count = wave_enemy_count[i]
		for j in range (count):
			spawn_queue.append(enemy_type)
	spawn_queue.shuffle()


func start_wave():
	spawned = 0
	build_spawn_queue()
	spawn_timer.start(spawn_interval)


func player_entered(body):
	if body.is_in_group("Player"):
		start_wave()


func spawn_timer_timeout():
	if spawn_queue.is_empty():
		if is_fighting_boss:
			build_spawn_queue()
			spawn_timer.start(spawn_interval)
		return
	var enemy_id = spawn_queue.pop_front()
	if enemy_types[enemy_id] == "":
		spawn_timer.start(spawn_interval)
		return
	var enemy_instance = load(enemy_types[enemy_id]).instantiate()
	spawned = spawned + 1
	var spawn_pos = get_node(door_spawn[spawn_point])
	var spawn = spawn_pos.global_position
	spawn_point = 1 - spawn_point
	add_child(enemy_instance)
	enemy_instance.global_position = spawn
	spawn_timer.start(spawn_interval)
	


func respawn():
	spawn_timer.stop()
	for enemy in get_tree().get_nodes_in_group("Enemy"):
		enemy.queue_free()
	spawned = 0
	build_spawn_queue()
	while spawn_queue.size() > 0 :
		var enemy_id = spawn_queue.pop_front()
		if enemy_types[enemy_id] == "":
			continue
		var enemy_instance = load(enemy_types[enemy_id]).instantiate()
		spawned = spawned + 1
		var spawn_pos = get_node(door_spawn[spawn_point])
		var spawn = spawn_pos.global_position
		spawn_point = 1 - spawn_point
		add_child(enemy_instance)
		enemy_instance.global_position = spawn


func fighting_boss(val: bool):
	is_fighting_boss = val
	if val and spawn_timer.is_stopped():
		build_spawn_queue()
		spawn_timer.start(spawn_interval)
