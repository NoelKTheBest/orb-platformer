extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimationPlayer.play("idle")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("an orb is close")
	$AnimationPlayer.stop()
	$AnimationPlayer.play("block")
	$AnimationPlayer.is_playing()
