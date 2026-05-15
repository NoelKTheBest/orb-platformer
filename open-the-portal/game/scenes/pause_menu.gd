extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	get_tree().paused = false


# Why use _input() here?
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true


func _on_resume_button_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_controls_screen_button_pressed() -> void:
	$VBoxContainer.visible = false
	$VBoxContainer2.visible = true


func _on_back_button_pressed() -> void:
	$VBoxContainer.visible = true
	$VBoxContainer2.visible = false


func _on_level_select_button_pressed() -> void:
	#var level_select = load("res://game/scenes/level_select.tscn").instantiate()
	
	var current_scene = get_tree().current_scene
	var root = get_tree().root
	root.add_child(SceneManager.level_select_scene)
	get_tree().current_scene = SceneManager.level_select_scene
	root.remove_child(current_scene) # current_scene or self
	current_scene.queue_free() 
		# This scene can be deleted bc if we want to restart 
		# the level after playing a different one, we don't 
		#want to pick up where we left off
	#breakpoint
