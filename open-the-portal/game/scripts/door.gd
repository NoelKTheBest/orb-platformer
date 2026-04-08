extends Polygon2D

signal _player_can_use_door

var show_label
var player_can_use_door

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Area2D.has_overlapping_bodies():
		if show_label: 
			_player_can_use_door.emit()
			$Label.visible = true
			player_can_use_door = true
	else:
		$Label.visible = false
		player_can_use_door = false
