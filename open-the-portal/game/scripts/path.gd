extends Path2D
@onready var path_follow_2d: PathFollow2D = $PathFollow2D

signal cycle_finished
signal progress_updated

var ratio_inc
var index: int = 1
@export var directions : PackedVector2Array = [Vector2(1, 1), Vector2(1, 0), Vector2(1, -1)]
@export var flip_directions : PackedVector2Array = [Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for dir in directions:
		dir = dir.normalized()
	# Divide progress ratio of 1 by amount of additional points
	# 1 / 2 = 0.5 so to get to the next point, increment progress ratio by about that much
	# Equation: 1 / (point_count - 1)
	#	1 / (3 - 1) = 1 / 2 = 0.5 #Increment by 0.5
	#	1 / (5 - 1) = 1 / 4 = 0.25 #Increment by 0.25
	# 1 / 6 no
	#@warning_ignore("integer_division")
	if curve.point_count % 2 != 0:
		ratio_inc = 1 / (float(curve.point_count) - 1)
	else:
		print("There needs to be an odd number of points in the curve")


func start_progression():
	path_follow_2d.progress_ratio = 0
	$Timer.start()
	index = 1
	print_rich("[color=green]index: ", index)


func update_progress_ratio():
	#print()
	#print(path_follow_2d.progress_ratio)
	index += 1
	if index > curve.point_count:
		cycle_finished.emit()
		path_follow_2d.progress_ratio = 0
		index = 1
	else:
		path_follow_2d.progress_ratio += ratio_inc
		print_rich("[color=green]index: ", index)
		progress_updated.emit()
		$Timer.start()


func _on_timer_timeout() -> void:
	update_progress_ratio()
