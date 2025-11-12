extends RigidBody2D

@export var launch_vector: Vector2
@onready var linear_v


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	#apply_force(launch_vector)
	#apply_central_force()
	pass


func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	print("shape collision")
	#launch_vector.x *= -1


func _on_body_entered(_body: Node) -> void:
	print("collision")
	#launch_vector.x * -1


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_tree_entered() -> void:
	linear_velocity = linear_v
	#print(linear_v)


func _on_timer_timeout() -> void:
	queue_free()
