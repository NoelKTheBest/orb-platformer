extends Control

var full_color = Color("2954ff")
var blank_color = Color("2954ff00")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_health(health: int):
	match health:
		3:
			$CanvasLayer/ColorRect/ColorRect3.color = full_color
			$CanvasLayer/ColorRect/ColorRect2.color = full_color
			$CanvasLayer/ColorRect/ColorRect.color = full_color
		2:
			$CanvasLayer/ColorRect/ColorRect3.color = blank_color
			$CanvasLayer/ColorRect/ColorRect2.color = full_color
			$CanvasLayer/ColorRect/ColorRect.color = full_color
		1:
			$CanvasLayer/ColorRect/ColorRect3.color = blank_color
			$CanvasLayer/ColorRect/ColorRect2.color = blank_color
			$CanvasLayer/ColorRect/ColorRect.color = full_color
		0:
			$CanvasLayer/ColorRect/ColorRect3.color = blank_color
			$CanvasLayer/ColorRect/ColorRect2.color = blank_color
			$CanvasLayer/ColorRect/ColorRect.color = blank_color
