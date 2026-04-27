extends Polygon2D

signal _player_can_use_door

var show_label
var player_can_use_door

@export var door: Node2D
@export var goes_down: bool = false
@export var floor_number: int = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Area2D.has_overlapping_bodies():
		if $Area2D.get_overlapping_bodies()[0].name == "Player":
			if show_label: 
				_player_can_use_door.emit()
				$Label.visible = true
				player_can_use_door = true
	else:
		$Label.visible = false
		player_can_use_door = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		if door: body.position = door.position
