extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x_dir = Input.get_axis("move_left", "move_right")
	var y_dir = Input.get_axis("move_down", "move_up")
	
	print(x_dir, y_dir)
