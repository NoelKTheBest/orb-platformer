extends RigidBody2D

@export var launch_vector: Vector2
@onready var linear_v


func _process(_delta: float) -> void:
	if get_colliding_bodies().size() > 0:
		queue_free()
	
	if get_contact_count() > 0:
		queue_free()


func _on_body_entered(_body: Node) -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_tree_entered() -> void:
	linear_velocity = linear_v


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_shape_entered(_body_rid: RID, _body: Node, _body_shape_index: int, _local_shape_index: int) -> void:
	queue_free()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()
