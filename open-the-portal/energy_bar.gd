extends ProgressBar

signal energy_exhausted

@export var value_inc = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if value < max_value:
		value += value_inc


func consume(amount: int):
	value -= amount
	
	if value == min_value:
		energy_exhausted.emit()
