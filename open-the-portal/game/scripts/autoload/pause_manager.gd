extends Node

var pause_menu = null

func toggle_pause():
	var is_paused = get_tree().paused
	get_tree().paused = !is_paused

	if pause_menu:
		pause_menu.visible = !is_paused
