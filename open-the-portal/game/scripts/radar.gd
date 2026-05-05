#@tool
extends Node2D

var main_rect := Rect2(0, 0, 2000, 2000)
var floor_areas
var empty_rect := Rect2(0, 0, 0, 0)
var intersection


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	floor_areas = get_tree().get_nodes_in_group("Floor Areas")
	#var rpos = $Area2D/CollisionShape2D.shape.get_rect().position
	#get_child(0)
	print($Area2D/CollisionShape2D.shape.get_rect())
	print($Area2D/CollisionShape2D.shape.get_rect().position)
	$Area2D/CollisionShape2D.shape.get_rect().position = Vector2.ZERO
	print($Area2D/CollisionShape2D.shape.get_rect().position)
	#print(to_global($Area2D/CollisionShape2D.shape.get_rect().position))
	#print(to_local($Area2D/CollisionShape2D.shape.get_rect().position))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _draw() -> void:
	# We know the math to get the starting point and edges and we have the right numbers to do
	# the proper calculations. The only thing to do now is to right some math equations to calculate
	# a better rectangle representation for the floor areas
	
	
	
	draw_rect(main_rect, Color.DEEP_SKY_BLUE)
	for area in floor_areas:
		var mri = main_rect.intersection(area.get_child(0).shape.get_rect())
		if mri != empty_rect:
			mri.size = area.get_child(0).shape.get_rect().size
			mri.position = area.position - (mri.size / 2)
		draw_rect(mri, Color.ORANGE, true)
		print(mri.position)


# Render an image to display to the radar component
func get_image() -> void:
	for area in floor_areas:
		pass
	pass
