extends Node2D

@export var sp_spacing = 80
@export var visible_sp = true
@export var total_number_of_enemy_1: int
@export var enemy_2_mod: int = 3
@export var total_number_of_enemies: int = 15

var enemy_scene = preload("res://prototype_2/prototype_2_enemy.tscn")
var assassin = preload("res://prototype_2/assassin.tscn")
var godotbot = preload("res://icon.svg")
var enemies_on_screen
var enemies_affected_by_anti_g = []
var enemy_spawn_point1: Vector2
var enemy_spawn_point2: Vector2
var espi : int = 0
var spawn_toggle = 0
var player_is_ready = false
var player_is_dead = false
var total_enemies_spawned
var sprite1
var sprite2
var sp_toggle = 0
var level_rect
var enemy_2_mod_rem

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var player: CharacterBody2D = $Player
@onready var lwp: Node2D = $LeftWallPosition
@onready var rwp: Node2D = $RightWallPosition


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_enemies_spawned = get_tree().get_nodes_in_group("Enemy").size()
	print("total_enemies_spawned % total_number_of_enemy_2: ", total_enemies_spawned % enemy_2_mod)
	enemy_2_mod_rem = total_enemies_spawned % enemy_2_mod
	sprite1 = Sprite2D.new()
	sprite2 = Sprite2D.new()
	add_child(sprite1)
	add_child(sprite2)
	sprite1.scale = Vector2(0.09, 0.09)
	sprite2.scale = Vector2(0.09, 0.09)
	sprite1.texture = godotbot
	sprite2.texture = godotbot
	level_rect = $Area2D/CollisionShape2D.shape.get_rect()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies_on_screen = get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible)
	
	if player_is_ready and !player_is_dead:
		var enemies = get_tree().get_nodes_in_group("Enemy")
		for enemy in enemies:
			enemy.monitor_player_position = true
			enemy.player_position = player.position
	
	if !player_is_dead:
		enemy_spawn_point1 = player.position - Vector2(sp_spacing, 5)
		enemy_spawn_point2 = player.position + Vector2(sp_spacing, -5)
		
		if (player.position.x - lwp.position.x) < sp_spacing:
			var x = (player.position.x - lwp.position.x) / 2
			enemy_spawn_point1 = Vector2(x, enemy_spawn_point1.y)
		if (rwp.position.x - player.position.x) < sp_spacing:
			var x = (rwp.position.x - player.position.x) / 2 + player.position.x
			enemy_spawn_point2 = Vector2(x, enemy_spawn_point2.y)
		sprite1.position = enemy_spawn_point1
		sprite2.position = enemy_spawn_point2
	
	if visible_sp:
		sprite1.visible = true
		sprite2.visible = true
	else:
		sprite1.visible = false
		sprite2.visible = false


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
	if total_enemies_spawned != total_number_of_enemies:
		var new_enemy
		if total_enemies_spawned % enemy_2_mod == enemy_2_mod_rem:
			new_enemy = assassin.instantiate()
		else:
			new_enemy = enemy_scene.instantiate()
		
		if !player_is_dead:
			match sp_toggle:
				0:
					add_child(new_enemy)
					new_enemy.position = enemy_spawn_point1
					sp_toggle = 1 - sp_toggle
				1:
					add_child(new_enemy)
					new_enemy.position = enemy_spawn_point2
					sp_toggle = 1 - sp_toggle
		
		if total_enemies_spawned < total_number_of_enemies: 
			total_enemies_spawned += 1
			$EnemySpawnInterval.start()
			print("Enemies left: ", total_number_of_enemies - total_enemies_spawned)
		else:
			pass
