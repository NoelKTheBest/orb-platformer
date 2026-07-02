@tool
extends Node2D

var enemy_label_scene = preload("res://game/scenes/enemy_placement_label.tscn")
var enemy_placements = []
var num_placements: int

#@export var on_death_enemy_placements = [["Mercenary"],[Vector2(0, 0)]]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in num_placements:
		enemy_placements.append(enemy_label_scene.instantiate())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): print(delta)


func _draw() -> void:
	if Engine.is_editor_hint():
		var default_font = ThemeDB.fallback_font
		var default_font_size = ThemeDB.fallback_font_size
		draw_string(default_font, Vector2(6, 4), "Hello world", HORIZONTAL_ALIGNMENT_LEFT, -1, default_font_size)
