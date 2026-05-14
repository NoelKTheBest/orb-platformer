extends Control

@onready var h_box_container: HBoxContainer = $HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for texture in h_box_container.get_children():
		texture.visible = false


func obtain_collectable(id: int):
	match id:
		0:
			h_box_container.get_child(0).visible = true
		1:
			h_box_container.get_child(1).visible = true
		2:
			h_box_container.get_child(2).visible = true
		3:
			h_box_container.get_child(3).visible = true


func all_collectables_obtained() -> bool:
	var are_all_visible = true
	for texture in get_children():
		if texture.visible == false: are_all_visible = false
	
	return are_all_visible
