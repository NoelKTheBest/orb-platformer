extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()


func _process(_delta: float) -> void:
	print("playing: ", playing)
	if !playing: queue_free()
