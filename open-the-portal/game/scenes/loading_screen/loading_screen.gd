extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String # Determines which scene to load
#@export var parameters: Dictionary # Temporarily stores parameters to be passed to target scene


func _ready():
	ResourceLoader.load_threaded_request(next_scene_path) # Starts the loading process behind the scenes


func _process(_delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED: # Checks to see if the file is finished loading
		set_process(false) # Stops the process function; otherwise this block will be called multiple times and cause errors
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path) # Gets the loaded scene, which is packed, so it'll have to be manually instantiated
		var new_node = new_scene.instantiate() # Instantiates a copy of the loaded scene
		#new_node.parameters = parameters # Assigns parameters to new scene
		
		#breakpoint
		# We can use ref counted to keep track of how many refs to the level select screen exist
		# Todo: set up a refcount monitor later on that tracks how many refs to the level select scene exist so we can prevent memory leaks
		# ref current_scene gets destroyed after this functions leaves the stack
		var current_scene = get_tree().current_scene # Stores the currently active scene, so we can replace it later
		
		get_tree().get_root().add_child(new_node) # Adds the new scene to the scene tree. This MUST happen before assigning it as the current scene.
		get_tree().current_scene = new_node # Assigns our new scene as the current scene
		
		# Here we set another ref in the autoload SceneManager to the level select scene
		#SceneManager.level_select_scene = current_scene
		get_tree().root.remove_child(current_scene) # Remove the level select scene from the scene tree
		
		#current_scene.queue_free() # Now we can remove the original scene; also removes the level select scene as it is what current_scene is referencing here
		# we can try to just remove the loading screen and keep the level select
		
		# instead we will call queue_free() on this or self and 
		# let the loading screen get removed while the level select
		# screen persists in memory but not in the scene tree
		queue_free()
		#breakpoint
