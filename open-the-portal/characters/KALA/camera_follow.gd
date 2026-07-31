extends Node2D

## The amount added to the bottom to set the top limit of the camera
@export var camera_top_limit: int = -150

var current_bottom


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Camera2D.limit_top = current_bottom + camera_top_limit
