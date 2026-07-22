extends Area2D

signal state_changed(type)
## 0 for switch; 1 for lever
@export_range(0, 1, 1, "This will change the state 
machine type from switch (0) 
to lever (1)") var state_machine_type := 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Label.visible = true if has_overlapping_bodies() else false
	
	if $Label.visible and Input.is_action_just_pressed("interact"):
		state_changed.emit(state_machine_type)
		$Sprite2D.frame = 1 - $Sprite2D.frame
