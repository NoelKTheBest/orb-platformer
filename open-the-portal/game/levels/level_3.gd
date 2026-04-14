extends Node2D

const DEBUG = true
var bomb = preload("res://game/scenes/item.tscn")

@export var skip_cutscene = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if skip_cutscene and DEBUG:
		$LevelAnimations.seek(3.49, true)
		$Player.cutscene_active = false
		$Player/CameraFollow/Camera2D.make_current()
	else:
		$LevelCamera.make_current()
		$Player.cutscene_active = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_item_5") and DEBUG:
		var new_bomb = bomb.instantiate()
		new_bomb.id = 5
		add_child(new_bomb)
		new_bomb.position = Vector2(667, 465)


func pause_camera() -> void:
	$LevelAnimations.pause()
	print_rich("[color=skyblue]Hmmm...A bomb")
	await get_tree().create_timer(1.0).timeout
	$LevelAnimations.play()


func _on_level_animations_animation_finished(anim_name: StringName) -> void:
	if anim_name == "move_camera":
		$Player/CameraFollow/Camera2D.make_current()
		$Player.cutscene_active = false


func _on_gc2_body_entered(_body: Node2D) -> void:
	$LevelGeometry/Glass_Ceiling2.process_mode = Node.PROCESS_MODE_DISABLED
	$LevelGeometry/Glass_Ceiling2.visible = false


func _on_gc1_body_entered(_body: Node2D) -> void:
	$LevelGeometry/Glass_Ceiling.process_mode = Node.PROCESS_MODE_DISABLED
	$LevelGeometry/Glass_Ceiling.visible = false
