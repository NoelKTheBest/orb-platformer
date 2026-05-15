@tool
extends Control
class_name LevelIcon

@export var level_name := "1"
@export var descriptive_name := ""
@export_file("*.tscn") var next_scene_path: String
@export var next_level_up: LevelIcon
@export var next_level_down: LevelIcon
@export var next_level_left: LevelIcon
@export var next_level_right: LevelIcon

var is_selected


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "Level " + str(level_name)
	$Label2.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$Label.text = "Level " + str(level_name)
	
	$Label2.visible = true if is_selected else false
