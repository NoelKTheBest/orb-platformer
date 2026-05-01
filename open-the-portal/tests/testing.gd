extends Node2D


@export var z_dist: float = 2.271

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$SubViewportContainer/SubViewport/Camera3D.position.z = z_dist
