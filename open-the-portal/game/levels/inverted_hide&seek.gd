extends Node

@onready var enemy: CharacterBody2D = $Enemy

var doors
var areas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LevelCamera.make_current()
	#$Enemy/Camera2D.make_current()
	doors = get_tree().get_nodes_in_group("Door")
	areas = get_tree().get_nodes_in_group("Floor Areas")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var player_floor_num
	
	for area in areas:
		# If the 
		if area.has_overlapping_bodies():
			for entity in area.get_overlapping_bodies():
				if entity.is_in_group("Player"): player_floor_num = area.floor_number
			
	if enemy.current_floor != player_floor_num:
		find_nearest_door()
	else:
		enemy.camera_position = $Player.position
		enemy.listen_for_player_coords = true
		enemy.nearest_door_position = Vector2.ZERO


# Find nearest door that goes up or down
func find_nearest_door():
	var dist: float = 100000000000
	for door in doors:
		var comp_d = $Enemy.position.distance_squared_to(door.position)
		var going_down: bool = false
		if enemy.position.y - $Player.position.y < 0: going_down = true
		
		#print("door: ", door.name, " ; down? ", door.goes_down, " ; floors match? ", door.floor_number == enemy.current_floor)
		if comp_d < dist and door.goes_down == going_down and door.floor_number == enemy.current_floor:
			dist = comp_d
			$Enemy.nearest_door_position = door.position
			enemy.monitor_player_position = true
