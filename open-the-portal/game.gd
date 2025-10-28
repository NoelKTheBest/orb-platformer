extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(Engine.get_frames_per_second())
	pass


func _on_enemy_enemy_on_screen() -> void:
	$Player.enemy_node = get_node("Enemy")
