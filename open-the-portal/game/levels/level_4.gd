extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelCamera.make_current()


func pause_camera() -> void:
	$CameraAnimator.pause()
	await get_tree().create_timer(1.0).timeout
	$CameraAnimator.play()
