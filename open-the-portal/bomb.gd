extends RigidBody2D
@export var x_velocity: int = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.set_collision_layer_value(12, false)
	$Area2D.visible = false
	apply_impulse(Vector2(x_velocity, 0), Vector2(0, 0))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node) -> void:
	$Timer.start(0.2)
	$Area2D.set_collision_layer_value(12, true)
	$Area2D.visible = true


func _on_timer_timeout() -> void:
	$Area2D.set_collision_layer_value(12, false)
	$Area2D.visible = false
	queue_free()
