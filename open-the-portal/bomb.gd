extends RigidBody2D
@export var x_velocity: int = 225
@export var y_velocity: int = -200
var direction = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BombBlastRadius.set_collision_layer_value(12, false)
	$BombBlastRadius.visible = false
	apply_impulse(Vector2(x_velocity * direction, y_velocity), Vector2(0, 0))


func _on_body_entered(_body: Node) -> void:
	$Timer.start(0.2)
	$BombBlastRadius.set_collision_layer_value(12, true)
	$BombBlastRadius.visible = true


func _on_timer_timeout() -> void:
	$BombBlastRadius.set_collision_layer_value(12, false)
	$BombBlastRadius.visible = false
	queue_free()
