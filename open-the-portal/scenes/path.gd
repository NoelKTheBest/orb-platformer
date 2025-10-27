extends Path2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(curve.get_point_in(0))
	print(curve.get_baked_points())
	print(curve.get_point_position(0))
	print(curve.point_count)
	
	# Divide progress ratio of 1 by amount of additional points
	# 1 / 2 = 0.5 so to get to the next point, increment progress ratio by about that much
	# Equation: 1 / (point_count - 1)
	#	1 / (3 - 1) = 1 / 2 = 0.5 #Increment by 0.5
	#	1 / (5 - 1) = 1 / 4 = 0.25 #Increment by 0.25
	# 1 / 6 no
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
