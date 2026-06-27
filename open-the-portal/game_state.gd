extends Node

@export var grid_areas = {
	"00": "",
	"01": "",
	"02": "",
	"03": "",
	"10": "",
	"11": "",
	"12": "",
	"13": "",
	"20": "",
	"21": "",
	"22": "",
	"23": "",
}

var wave_key = "current wave"
var area_key = "areas cleared"
var room_clear_key = "rooms cleared"
var player_death_key = "player deaths"
var current_state = {}

var survivor_position := GridCoordinate.new()
var boss_position := GridCoordinate.new()
var enemy_position := GridCoordinate.new()
var grid = [
	[0, 0, 0, 0],
	[0, 0, 0, 0],
	[0, 0, 0, 0],
]
var astargrid = AStarGrid2D.new()


func initialize_dictionary():
	current_state[wave_key] = 1
	current_state[area_key] = 0
	current_state[room_clear_key] = 0
	current_state[player_death_key] = 0


func switch_to_next_wave():
	current_state[wave_key] += 1 # Increment wave state
	current_state[area_key] = 0 # Clear areas cleared state
	current_state[room_clear_key] = 0 # Clear rooms cleared state
	current_state[player_death_key] = 0 # Clear player deaths state


func clear_area():
	current_state[area_key] += 1 # Increment areas cleared state
	current_state[room_clear_key] = 0 # Clear rooms cleared state
	current_state[player_death_key] = 0 # Clear player deaths state


func clear_room():
	current_state[room_clear_key] += 1 # Increment rooms cleared state


func register_death():
	current_state[player_death_key] += 1


func setup_grid():
	astargrid.region = Rect2i(0, 0, 4, 3)
	astargrid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid.update()
	var i = 0
	var j = 0
	for row in grid:
		for column in row:
			astargrid.set_point_solid(Vector2i(i, j), is_cell_survivor_occupied(Vector2i(i, j)))
			i += 1
		j += 1


func show_path(start_x: int, start_y: int, end_x: int, end_y: int):
	var _path_taken = astargrid.get_id_path(Vector2(start_x, start_y), Vector2(end_x, end_y))


func is_cell_survivor_occupied(cell: Vector2i) -> bool:
	return true if grid[cell.x][cell.y] > 0 else false


class GridCoordinate:
	## Determines the vertical column along the x axis
	var column: int
	## Determines the horizontal row along the y axis
	var row: int
