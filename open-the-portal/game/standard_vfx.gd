extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(animation)


func _process(_delta: float) -> void:
	if !is_playing(): queue_free()
