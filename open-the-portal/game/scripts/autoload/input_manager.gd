extends Node

var pause_menu = null
var is_paused := false

func toggle_pause():
	is_paused = !is_paused

	get_tree().paused = is_paused

	if pause_menu:
		pause_menu.visible = is_paused

	print("PAUSE STATE:", is_paused)
