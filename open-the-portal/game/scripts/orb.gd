extends RigidBody2D

@export var launch_vector: Vector2
@onready var linear_v

var has_bullet_hit_anything : bool = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_tree_entered() -> void:
	linear_velocity = linear_v


func _on_timer_timeout() -> void:
	queue_free()
