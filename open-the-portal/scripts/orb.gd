extends RigidBody2D

@export var launch_vector: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


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
