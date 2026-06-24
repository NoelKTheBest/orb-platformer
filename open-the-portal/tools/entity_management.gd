@tool
extends EditorScript

## The wave we are currently editing for
var curr_wave

func _run() -> void:
	# Get scene
	var curr_scene = get_scene()
	# Get all entity nodes of current scene
	var entities = []
	for c in curr_scene.get_children():
		if typeof(c) == typeof(BasicEntity): # may not work
			entities.append(c)
	pass
