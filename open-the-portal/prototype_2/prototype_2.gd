extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func enemy_is_visible(enemy):
	if enemy.visible_on_screen_notifier_2d.is_on_screen(): return enemy


func _on_player_anti_gravity_zone_created() -> void:
	var enemies = get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible)
	#print(enemies)
	$ZeroGravityZoneTimer.start()


func _on_zero_gravity_zone_timer_timeout() -> void:
	for enemy in get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible):
		enemy.in_anti_gravity_zone = false
