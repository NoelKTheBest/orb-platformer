extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var grid_pos = GameState.player_grid_position
	var x_dir = Input.get_axis("move_left", "move_right")
	var y_dir = Input.get_axis("move_down", "move_up")
	
	if x_dir or y_dir:
		var init_value = GameState.grid[grid_pos.row][grid_pos.column]
		GameState.grid[grid_pos.row][grid_pos.column] = 0
		
		if Input.is_action_just_pressed("move_left"):
			grid_pos.column += -1
			grid_pos.column = clampi(grid_pos.column, 0, GameState.grid[0].size() - 1)
			if check_for_boss(grid_pos): grid_pos.column += 1
			GameState.run_sim()
		elif Input.is_action_just_pressed("move_right"):
			grid_pos.column += 1
			grid_pos.column = clampi(grid_pos.column, 0, GameState.grid[0].size() - 1)
			if check_for_boss(grid_pos): grid_pos.column += -1
			GameState.run_sim()
		if Input.is_action_just_pressed("move_down"):
			grid_pos.row += 1
			grid_pos.row = clampi(grid_pos.row, 0, GameState.grid.size() - 1)
			if check_for_boss(grid_pos): grid_pos.row += -1
			GameState.run_sim()
		if Input.is_action_just_pressed("move_up"):
			grid_pos.row += -1
			grid_pos.row = clampi(grid_pos.row, 0, GameState.grid.size() - 1)
			if check_for_boss(grid_pos): grid_pos.row += 1
			GameState.run_sim()
		
		GameState.grid[grid_pos.row][grid_pos.column] = 3
		get_parent().redraw()
	
	#print(grid_pos.row, grid_pos.column)


func check_for_boss(pos):
	if GameState.grid[pos.row][pos.column] == 2:
		return true
	else:
		return false
