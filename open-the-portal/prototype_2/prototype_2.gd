extends Node2D

var enemies_on_screen
var enemies_affected_by_anti_g = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	enemies_on_screen = get_tree().get_nodes_in_group("Enemy").filter(enemy_is_visible)


func enemy_is_visible(enemy):
	if enemy.visible_on_screen_notifier_2d.is_on_screen(): return enemy


func _on_player_anti_gravity_zone_created() -> void:
	for enemy in enemies_on_screen:
		enemy.player_position = $Player.position
		enemy.launch()
		enemies_affected_by_anti_g.append(enemy)
	#print(enemies)
	$ZeroGravityZoneTimer.start()


func _on_zero_gravity_zone_timer_timeout() -> void:
	for enemy in enemies_affected_by_anti_g:
		enemy.in_anti_gravity_zone = false
	
	$Player.in_anti_gravity_zone = false
	enemies_affected_by_anti_g = []
