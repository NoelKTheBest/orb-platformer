extends PointLight2D

var light_on = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = light_on


func _on_timer_timeout() -> void:
	light_on = !light_on
	enabled = light_on
