extends Node

# preloading this makes the level select scene (which is small) always loaded into the project memory
#var level_select_scene = preload("res://game/scenes/level_select.tscn")

# the level select scene is already loaded into memory once 
# the game loads, save a referrence to it with this autoload
var level_select_scene


func switch_to_level_select():
	pass
