extends Control

@onready var worlds: Array = [$WorldIcon, $WorldIcon2, $WorldIcon3]
var current_world: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PlayerIcon.global_position = worlds[current_world].global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left") and current_world > 0:
		current_world -= 1
		$PlayerIcon.global_position = worlds[current_world].global_position
	elif event.is_action_pressed("move_right") and current_world < worlds.size() - 1:
		current_world += 1
		$PlayerIcon.global_position = worlds[current_world].global_position

	if event.is_action_pressed("ui_accept"):
		if worlds[current_world].level_select_scene:
			worlds[current_world].level_select_scene.parent_world_select = self
			get_tree().get_root().add_child(worlds[current_world].level_select_scene)
			get_tree().current_scene = worlds[current_world].level_select_scene
			get_tree().get_root().remove_child(self)
