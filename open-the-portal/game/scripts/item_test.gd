extends Node2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$TimeIsUp.start()
	
	if body.is_in_group("Orbs"):
		$Wall.process_mode = Node.PROCESS_MODE_DISABLED
		$Wall.visible = false
		$ReEnable.start()


func _on_time_is_up_timeout() -> void:
	if !$Area2D.has_overlapping_bodies():
		return
	#else:
	$Wall.process_mode = Node.PROCESS_MODE_DISABLED
	$Wall.visible = false
	$ReEnable.start()


func _on_re_enable_timeout() -> void:
	$Wall.process_mode = Node.PROCESS_MODE_INHERIT
	$Wall.visible = true
