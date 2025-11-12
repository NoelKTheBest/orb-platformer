extends Area2D

signal player_was_hit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area.visible:
			player_was_hit.emit()
			break
		print("area.visible: ", area.visible)
