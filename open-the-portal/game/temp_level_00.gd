extends Node2D

@export var sp_spacing = 80
@export var visible_sp = true
@export var total_number_of_enemy_1: int
## Used to calculate how often secondary enemy types are spawned. The higher the number, the less frequently secondary enemies spawn
@export var enemy_2_mod: int = 3
@export var total_number_of_enemies: int = 15
## Number of enemies to be spawned at spawn points
@export var spawn_point_enemy_count: int = 2
## Determines how close player should be before an enemy spawn there
@export var spawn_point_range = 150

#region private vars
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
var num_enemy_left
var sprite1
var sprite2
var sp_toggle = 0
var level_rect
var enemy_2_mod_rem
var controller_is_dead = false
var spawn_point_rate
var player_close_to_sp1 = false
var player_close_to_sp2 = false

@onready var enemy_spawn_timer: Timer = $EnemySpawnTimer
@onready var player: CharacterBody2D = $Player
@onready var lwp: Node2D = $LeftWallPosition
@onready var rwp: Node2D = $RightWallPosition
# Spawn Points
@onready var spawn_point_1: Sprite2D = $SpawnPoint1
@onready var spawn_point_2: Sprite2D = $SpawnPoint2

#endregion

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Engine.time_scale = 0.5
	total_number_of_enemies += spawn_point_enemy_count
	total_enemies_spawned = get_tree().get_nodes_in_group("Enemy").size()
	num_enemy_left = total_number_of_enemies - total_enemies_spawned
	print("enemies left: ", num_enemy_left)
	#print("total_enemies_spawned % total_number_of_enemy_2: ", total_enemies_spawned % enemy_2_mod)
	@warning_ignore("integer_division")
	print("total num of enemies: ", total_number_of_enemies, "; Spawn Point Rate: ",  total_number_of_enemies / spawn_point_enemy_count)
	
	# Take initial secondary enemy ratio and use it to determine secondary enemy spawn rate
	enemy_2_mod_rem = total_enemies_spawned % enemy_2_mod
	
	# Set Spawn Point Usage Rate
	@warning_ignore("integer_division")
	spawn_point_rate = (total_number_of_enemies / spawn_point_enemy_count) - 3
	print("rem: ", 8 % spawn_point_rate, "; 2nd rem: ", 16 % spawn_point_rate, "; 3rd rem: ", 12 % spawn_point_rate)
	
	# Setup
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
			enemy.walking = false
	
	if !controller_is_dead:
		$ForcefieldController.monitor_player_position = true
		if !player_is_dead: $ForcefieldController.player_position = player.position
		$ForcefieldController.number_of_enemies = get_tree().get_nodes_in_group("Enemy").size()
		$ForcefieldController.return_point_x = $ReturnPoint.position.x
	else:
		if get_tree().get_nodes_in_group("Enemy").size() == 0 and $Forcefield != null: $Forcefield.queue_free()
	
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

#region Signals


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
		# Continuously check to see if a mod operation returns a remainder that matches the initial secondary enemy ratio
		if total_enemies_spawned % enemy_2_mod == enemy_2_mod_rem:
			new_enemy = assassin.instantiate()
		else:
			new_enemy = enemy_scene.instantiate()
		
		var spawn_point_rem = total_enemies_spawned % spawn_point_rate
		var use_spawn_point = false
		var player_is_close = false
		if (total_enemies_spawned % spawn_point_rate == 0): use_spawn_point = true
		
		if !player_is_dead and use_spawn_point:
			if abs(player.position.x - spawn_point_1.position.x) < spawn_point_range:
				print("near sp1")
				player_is_close = true
				add_child(new_enemy)
				new_enemy.position = spawn_point_1.position
			elif abs(player.position.x - spawn_point_2.position.x) < spawn_point_range:
				print("near sp2")
				player_is_close = true
				add_child(new_enemy)
				new_enemy.position = spawn_point_2.position
		
		if !player_is_dead and !player_is_close:
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
			num_enemy_left = total_number_of_enemies - total_enemies_spawned
			print("Enemies left: ", num_enemy_left)
		else:
			pass


func _on_forcefield_controller_controller_dead() -> void:
	controller_is_dead = true
	if get_tree().get_nodes_in_group("Enemy").size() == 0: $Forcefield.queue_free()


func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$CanvasLayer/Label.visible = true
		$YouWinTimer.start()


func _on_you_win_timer_timeout() -> void:
	get_tree().quit()
#endregion
