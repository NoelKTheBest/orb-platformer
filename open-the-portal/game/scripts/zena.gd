extends MeshInstance3D

@export var spin_speed = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Mesh has stopped rotating properly after changing some setting in the scene view for the sky and ground color
	#print(delta * spin_speed)
	rotate_y(delta * spin_speed)
