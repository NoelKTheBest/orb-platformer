extends Node

@export var main_floor_num: int

#var floor1spawns = []
#var floor2spawns = []
#var floor3spawns = []
#var floor4spawns = []
#var floor5spawns = []

var doors: Array
var areas: Array
var enemies: Array

@onready var player: CharacterBody2D = $Player


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#$LevelCamera.make_current()
	doors = get_tree().get_nodes_in_group("Door")
	areas = get_tree().get_nodes_in_group("Floor Areas")
	enemies = get_tree().get_nodes_in_group("Enemy")
	
	#for sp in $SpawnPoints.get_children():
		#match sp.floor_number:
			#1:
				#floor1spawns.append(sp)
			#2:
				#floor2spawns.append(sp)
			#3:
				#floor3spawns.append(sp)
			#4:
				#floor4spawns.append(sp)
			#5:
				#floor5spawns.append(sp)
	for door in doors:
		door.show_label = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_floor_num
	# refresh enemy list
	enemies = get_tree().get_nodes_in_group("Enemy")
	
	# no reason to have this check here, this will need to be copied to every script that has more than one floor
	# give player.gd a current_floor var
	for area in areas:
		# If the 
		if area.has_overlapping_bodies():
			for entity in area.get_overlapping_bodies():
				if entity.is_in_group("Player"): player_floor_num = area.floor_number
	
	for enemy in enemies:
		# if both of these conditions are true, do one thing, in any other case, do the other thing
		if enemy.current_floor != player_floor_num:
			if !enemy.defend_position: find_objective_door(enemy, enemy.current_floor, player_floor_num)
		# in the case we are on the same floor as the player, fight them
		else:
			enemy.camera_position = player.position
			enemy.listen_for_player_coords = true
			enemy.nearest_door_position = Vector2.ZERO
			if enemy.defend_position: enemy.defend_position = false


func find_objective_door(entity: Node, ecf, pcf):
	var no_doors_found = true
	# Set door to main to always be Vector2.Zero in the case that while finding the right door, the interpreter doesn't get stuck
	var door_to_main = Vector2.ZERO
	# if both ecf and pcf are 0 (happens on frame 1), ingore clauses where this need to be false
	var no_current_floors = true if ecf == 0 and pcf == 0 else false
	# set destination floor of entity to player's current floor
	entity.destination_floor = pcf
	
	
	# get list of doors available to entity on certain floor
	var lod = doors.filter(func(door): return door.floor_number == ecf)
	
	# Each floor in the scene has more than one door, therefore we only need to loop through the doors on each floor
	for door in lod:
		#either find a door to the destination or find the door to the main floor
		if door.destination_floor == pcf:
			entity.nearest_door_position = door.position
			entity.monitor_player_position = true
			no_doors_found = false
		# if a door to the player is not found, get reference to door going to the main floor
		elif door.destination_floor == main_floor_num:
			door_to_main = door.position
	
	if no_doors_found and !no_current_floors:
		entity.destination_floor = main_floor_num
		entity.nearest_door_position = door_to_main
		entity.monitor_player_position = true
