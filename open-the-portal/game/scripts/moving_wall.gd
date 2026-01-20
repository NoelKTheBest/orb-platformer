extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("move")


func _process(delta: float) -> void:
	print($Wall.position)
