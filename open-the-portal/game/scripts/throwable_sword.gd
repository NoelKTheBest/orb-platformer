extends RigidBody2D

@onready var linear_v

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(position, global_position, visible)


func _on_body_entered(_body: Node) -> void:
	queue_free()


func _on_tree_entered() -> void:
	linear_velocity = linear_v
