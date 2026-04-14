extends Node2D

signal player_in_place
var signal_emitted = false

var enemies


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")
	$LevelCamera.make_current()
	$Player.cutscene_active = true
	$Enemy.cutscene_active = true
	$Enemy2.cutscene_active = true
	$Enemy3.cutscene_active = true
	$Enemy4.cutscene_active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies = get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies:
		enemy.player_position = $Player.position



func pause_camera() -> void:
	$LevelAnimations.pause()
	$Player/CameraFollow/Camera2D.make_current()
	$Player.cutscene_active = false
	await player_in_place
	$LevelAnimations.play()
	$Player.cutscene_active = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !signal_emitted:
		player_in_place.emit()
		$LevelCamera.make_current()
		$PointLight2D.enabled = true
		$PointLight2D2.enabled = true
		$PointLight2D3.enabled = true
		signal_emitted = true


func _on_level_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "move_camera":
		$Player/CameraFollow/Camera2D.make_current()
		$Player.cutscene_active = false
		
		for enemy in enemies:
			enemy.cutscene_active = false
			enemy.monitor_player_position = true
		
