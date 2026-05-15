extends Polygon2D

signal end_game

@export var player_node_name: String = "Player"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	
	# This only runs if the door's area has detectable physics bodies
	if bodies.size() > 0:
		for b in bodies:
			if b.name == player_node_name:
				if b.ready_to_advance and Input.is_action_just_pressed("use_door"):
					end_game.emit()
					get_tree().quit()
