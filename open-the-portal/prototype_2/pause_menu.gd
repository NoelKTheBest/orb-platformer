extends CanvasLayer

var waiting_action := ""
# renames and remaps in order
var bindings = [
	{"action": "move_left", "button": null},
	{"action": "move_right", "button": null},
	{"action": "jump", "button": null},
	{"action": "fire", "button": null},
	{"action": "power_fire", "button": null},
]

@onready var resume_button = $PauseMenu/VBoxContainer/Panel/VBoxContainer/ResumeButton


func _ready():
	PauseManager.pause_menu = self
	visible = false

	var buttons = find_children("*", "Button", true, false)

	var index := 0
	for b in buttons:
		if index >= bindings.size():
			break

		if b is Button:
			bindings[index].button = b
			b.pressed.connect(_on_rebind_pressed.bind(bindings[index].action))
			index += 1

	update_button_texts()


func _on_visibility_changed():
	if visible:
		update_button_texts()


func _input(event):
	if waiting_action == "":
		return

	if event is InputEventKey and event.pressed:
		rebind_action(waiting_action, event)
		waiting_action = ""
		update_button_texts()


func _on_rebind_pressed(action: String):
	waiting_action = action


func rebind_action(action: String, new_key: InputEventKey):
	var events = InputMap.action_get_events(action)

	for e in events:
		InputMap.action_erase_event(action, e)

	InputMap.action_add_event(action, new_key)


func update_button_texts():
	for item in bindings:
		if item.button == null:
			continue

		item.button.text = item.action.capitalize() + ": " + get_key_name(item.action)


func get_key_name(action: String) -> String:
	var events = InputMap.action_get_events(action)

	for e in events:
		if e is InputEventKey:
			return e.as_text()

	return "Unassigned"


func _on_resume_button_up() -> void:
	PauseManager.toggle_pause()
