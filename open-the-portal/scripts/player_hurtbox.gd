extends Area2D

signal player_was_hit
@onready var damage_taken_timer: Timer = $"../DamageTakenTimer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	for area in areas:
		if area.visible and damage_taken_timer.time_left == 0.0:
			player_was_hit.emit()
			damage_taken_timer.start()
			break
