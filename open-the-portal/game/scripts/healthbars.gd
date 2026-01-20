class_name HealthBar
extends Control

@export var full_color = Color("2954ff")
var blank_color = Color("2954ff00")

# Create and instantiate ColorRect nodes at runtime
# Set the properties of each


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func update_health(health: int):
	match health:
		3:
			$ColorRect/ColorRect3.color = full_color
			$ColorRect/ColorRect2.color = full_color
			$ColorRect/ColorRect.color = full_color
		2:
			$ColorRect/ColorRect3.color = blank_color
			$ColorRect/ColorRect2.color = full_color
			$ColorRect/ColorRect.color = full_color
		1:
			$ColorRect/ColorRect3.color = blank_color
			$ColorRect/ColorRect2.color = blank_color
			$ColorRect/ColorRect.color = full_color
		0:
			$ColorRect/ColorRect3.color = blank_color
			$ColorRect/ColorRect2.color = blank_color
			$ColorRect/ColorRect.color = blank_color
