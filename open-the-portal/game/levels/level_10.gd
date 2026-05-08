extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Saemi.monitor_player_position = true
	$Saemi.player_position = $Player.position


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area)


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body)
