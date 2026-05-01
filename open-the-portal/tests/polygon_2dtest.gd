extends Polygon2D

enum bar_types {POWER, NORMAL, INSTANT}

var game_tick_count
@export var ticks_needed = 0
@export var bar_type = bar_types.NORMAL

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_tick_count >= ticks_needed:
		visible = true
	else:
		visible = false
