extends Node2D

const DEBUG = true
@export var SKIP_CUTSCENE = true

signal door_is_broken
signal ally_was_killed
signal cam_to_2ndpos
signal dialog_finished
signal start_fight

#var state_machine = preload("res://game/basic_enemy_animtree.tres")
var camera_in_place = false
var on_bottom_floor = false
var all_enemies_dead = false

var enemies
var doors
var used_door = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !SKIP_CUTSCENE and DEBUG: 
		start_fight.connect(on_start_fight)
		doors = get_tree().get_nodes_in_group("Doors")
		for door in doors:
			door.show_label = false
		
		# autoplay on load: door break
		enemies = get_tree().get_nodes_in_group("Enemy")
		$LevelCamera.make_current()
		for enemy in enemies:
			enemy.cutscene_active = true
		$Player.cutscene_active = true
		await door_is_broken
		$LevelAnimations.play("move_camera")
		# _on_area_2d_area_entered
		await cam_to_2ndpos
		$Enemy3.attack = 1
		await $Enemy3/AnimationTree.animation_finished
		$LevelAnimations.play("kill_ally")
		await ally_was_killed
		$LevelAnimations.play("dialog")
		await dialog_finished
		for enemy in enemies:
			enemy.run = 1
		$LevelAnimations.play("move_cam2")
		# Run To Doors
		$Enemy.objective = $Doors/TL_Door.position
		$Enemy2.objective = $Doors/TR_Door.position
		$Enemy3.objective = $Doors/TR_Door.position
		for enemy in enemies:
			enemy.monitor_player_position = true
		#print($Enemy.monitor_player_position, "we ready?")
		#wait_at_door()
		#await $Doors/TR_Door/Area2D.body_entered
		#$Enemy2.visible = false
		#$Enemy3.visible = false
		
		#$Enemy.position = $Doors/BL_Door.position
		#$Enemy2.position = $Doors/BR_Door.position
		#$Enemy3.position = $Doors/BR_Door.position


func _process(_delta: float) -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")
	
	if !$UpperFloorArea.has_overlapping_bodies() and !on_bottom_floor:
		start_fight.emit()
	
	for enemy in enemies:
		enemy.player_position = $Player.position
	
	if enemies.size() == 0:
		all_enemies_dead = true
		for door in doors:
			door.show_label = true


func move_camera():
	$LevelCamera.position = $CameraPosition2.position


func print_dialog():
	print_rich("[color=orangered]What was that?")
	print_rich("[color=orange]Idk, let's find out")


func wait_at_door():
	await $Doors/TL_Door/Area2D.body_entered
	$Enemy.visible = false


func _on_level_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "door_is_broken": door_is_broken.emit()
	elif anim_name == "kill_ally": ally_was_killed.emit()
	elif anim_name == "dialog": dialog_finished.emit()
	elif anim_name == "move_cam_to_player":
		for enemy in enemies:
			enemy.cutscene_active = false
		
		$LevelCamera.position = $Player/CameraFollow.position
		$Player/CameraFollow/Camera2D.make_current()
		
		$Player.cutscene_active = false
		on_bottom_floor = true


func _on_area_2d_area_entered(_area: Area2D) -> void:
	cam_to_2ndpos.emit()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		if body.name == "Enemy":
			body.position = $Doors/BL_Door.position
		else:
			body.position = $Doors/BR_Door.position


func on_start_fight():
	$LevelAnimations.play("move_cam_to_player")


func _on_bl_door__player_can_use_door() -> void:
	if Input.is_action_just_pressed("use_door"):
		$Player.position = $Doors/TL_Door.position + Vector2(0, -10)


func _on_tl_door__player_can_use_door() -> void:
	if Input.is_action_just_pressed("use_door"):
		$Player.position = $Doors/BL_Door.position + Vector2(0, -10)


func _on_br_door__player_can_use_door() -> void:
	if Input.is_action_just_pressed("use_door"):
		$Player.position = $Doors/TR_Door.position + Vector2(0, -10)


func _on_tr_door__player_can_use_door() -> void:
	if Input.is_action_just_pressed("use_door"):
		$Player.position = $Doors/BR_Door.position + Vector2(0, -10)
