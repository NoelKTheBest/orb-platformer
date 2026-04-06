extends Node2D

var spd_val = 0.0
var atk_val = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	if Input.is_action_just_pressed("fire"):
		# Play child animation connected to "shot" port.
		$AnimationTree.set("parameters/OneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_RIGHT:
			spd_val += 0.1
			clampf(spd_val, 0.0, 0.3)
			$AnimationTree.set("parameters/BlendSpace1D/blend_position", spd_val)
		elif event.pressed and event.keycode == KEY_LEFT:
			spd_val -= 0.1
			clampf(spd_val, 0.0, 0.3)
			$AnimationTree.set("parameters/BlendSpace1D/blend_position", spd_val)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
