extends Node

@onready var enemy: CharacterBody2D = $Enemy

var doors
var areas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	doors = get_tree().get_nodes_in_group("Door")
	areas = get_tree().get_nodes_in_group("Floor Areas")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:	
	for area in areas:
		if area.has_overlapping_bodies():
			if enemy.current_floor != area:
				if enemy.nearest_door_position == Vector2.ZERO: find_nearest_door()
			else:
				enemy.camera_position = $Player.position
				enemy.listen_for_player_coords = true
				enemy.nearest_door_position = Vector2.ZERO


func find_nearest_door():
	var dist: float = 100000000000
	for door in doors:
		var comp_d = $Enemy.position.distance_squared_to(door.position)
		var going_down: bool = false
		if enemy.position.y - $Player.position.y < 0: going_down = true
		
		if comp_d < dist and door.goes_down == going_down:
			dist = comp_d
			$Enemy.nearest_door_position = door.position
