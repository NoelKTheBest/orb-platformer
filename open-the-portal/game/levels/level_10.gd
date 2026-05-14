extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Saemi.return_position = $ReturnPosition.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if $Saemi:
		$Saemi.monitor_player_position = true
		$Saemi.player_position = $Player.position
	#$Kala/CameraFollow/Camera2D.make_current()


func get_player_facing_direction():
	return $Player/Sprite2D.flip_h


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
