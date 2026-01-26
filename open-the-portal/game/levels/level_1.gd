extends Node2D

var player_can_use_door


func _on_door_player_can_use_door() -> void:
	pass # Replace with function body.


func _on_door_2_player_can_use_door() -> void:
	pass


func _on_player_use_door() -> void:
	print("trying")
	
	if $Door/Area2D.has_overlapping_bodies():
		print("use door")
		$Player.position = $Door2.position
