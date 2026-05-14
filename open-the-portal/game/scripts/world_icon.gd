@tool
extends Control

@export var world_index: int = 1
@export var level_select_packed: PackedScene = load("res://game/scenes/level_select.tscn")
@onready var level_select_scene: LevelSelect = level_select_packed.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = "World " + str(world_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		$Label.text = "World " + str(world_index)
