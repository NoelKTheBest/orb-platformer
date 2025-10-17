extends RigidBody2D

@export var launch_vector: Vector2
@onready var linear_v


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#apply_force(launch_vector)
	#apply_central_force()
	pass


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	print("collision")
	#launch_vector.x *= -1


func _on_body_entered(body: Node) -> void:
	#print("collision")
	#launch_vector.x * -1
	pass


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_tree_entered() -> void:
	linear_velocity = linear_v
	#print(linear_v)
