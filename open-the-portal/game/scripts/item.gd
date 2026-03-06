extends RigidBody2D

var id: int
var item_name: String

func ready():
	name = item_name


func _on_timer_timeout() -> void:
	queue_free()
