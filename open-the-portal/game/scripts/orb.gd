extends RigidBody2D

@export var launch_vector: Vector2
@onready var linear_v

var has_bullet_hit_anything : bool = false


func _process(_delta: float) -> void:
	if has_bullet_hit_anything: linear_velocity = Vector2(0,0)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_tree_entered() -> void:
	linear_velocity = linear_v
	if $BombBlastRadius: $BombBlastRadius.set_collision_layer_value(12, false)


func _on_timer_timeout() -> void:
	queue_free()


func _on_body_entered(_body: Node) -> void:
	if $BombBlastRadius: 
		$BombBlastRadius.set_collision_layer_value(12, true)
		$BombBlastRadius.visible = true
	if $AnimationPlayer: $AnimationPlayer.play("shockwave")
