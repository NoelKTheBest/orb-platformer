extends Node

var game_ticks = 0
@export var base_count = 1
var engine_start_time


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	engine_start_time = Time.get_ticks_msec()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#$Ticks.text = str(game_ticks)
	#$TimeMs.text = str(float((Time.get_ticks_msec() - engine_start_time)/1000))
	#if Input.is_action_just_pressed("instant_fire") and use_energy(2) != 1:
		#print("INSTANT")
	
	if Input.is_action_just_pressed("fire") and use_energy(4) != -1:
		print("FIRE")
	
	if Input.is_action_just_pressed("power_fire") and use_energy(8) != -1:
		print_rich("[color=orangered] BLAST")
	
	
	for bar in get_tree().get_nodes_in_group("Energy Bars"):
		bar.game_tick_count = game_ticks


func _on_timer_timeout() -> void:
	print(Time.get_ticks_msec() - engine_start_time)
	if game_ticks < 16:
		game_ticks += base_count
		$Node2D/Timer.start()
	else:
		$Node2D/Timer.one_shot = true
		#get_tree().quit()


func use_energy(energy_count: int):
	if game_ticks >= energy_count:
		game_ticks -= energy_count
		$Node2D/Timer.start()
	else: return -1
	
	return game_ticks
