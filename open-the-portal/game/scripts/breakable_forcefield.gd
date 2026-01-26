extends StaticBody2D

var anim_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_position = $AnimationPlayer2
	$AnimationPlayer.play("flash")
	if anim_position != null:
		anim_position.play("path1")


func _on_area_2d_wall_is_broken() -> void:
	queue_free()
