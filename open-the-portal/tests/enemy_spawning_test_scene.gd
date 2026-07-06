extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Enemy_Spawner.start_wave()
	pass # Replace with function body.

func _on_player_player_died() -> void:
	print("Player Died")
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
