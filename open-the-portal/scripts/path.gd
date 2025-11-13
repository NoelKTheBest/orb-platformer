extends Path2D

var ratio_inc

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Divide progress ratio of 1 by amount of additional points
	# 1 / 2 = 0.5 so to get to the next point, increment progress ratio by about that much
	# Equation: 1 / (point_count - 1)
	#	1 / (3 - 1) = 1 / 2 = 0.5 #Increment by 0.5
	#	1 / (5 - 1) = 1 / 4 = 0.25 #Increment by 0.25
	# 1 / 6 no
	@warning_ignore("integer_division")
	ratio_inc = 1 / (curve.point_count - 1)
	$PathFollow2D.progress_ratio = ratio_inc


func update_progress_ratio():
	$PathFollow2D.progress_ratio += ratio_inc
