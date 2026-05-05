#@tool
extends Node2D

@export var view_scale := Vector2.ONE
@export var draw_width := 5

var main_rect := Rect2(0, 0, 2000, 2000)
var floor_areas
var empty_rect := Rect2(0, 0, 0, 0)
var intersection
var prev_draw_width


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floor_areas = get_tree().get_nodes_in_group("Floor Areas")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if draw_width != prev_draw_width:
		queue_redraw()
	
	prev_draw_width = draw_width


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, view_scale)
	draw_rect(main_rect, Color.DEEP_SKY_BLUE)
	for area in floor_areas:
		var mri = main_rect.intersection(area.get_child(0).shape.get_rect())
		if mri != empty_rect:
			mri.size = area.get_child(0).shape.get_rect().size
			mri.position = area.position - (mri.size / 2)
		draw_rect(mri, Color.ORANGE, false, draw_width)
		print(mri.position)


# Render an image to display to the radar component
func get_image() -> void:
	for area in floor_areas:
		pass
	pass
