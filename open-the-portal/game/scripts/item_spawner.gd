extends Polygon2D

var item_scene : PackedScene = preload("res://game/scenes/item.tscn")
#@export var item_name : String
@export var item_id : int

const ITEM_NAMES = {
	1: "EMP",
	2: "Wall",
	3: "Sword",
	4: "Flash Grenade",
	5: "Bomb",
	6: "HP Restore",
	7: "Energy Restore",
	#1: "Energy Regen Power-up",
	#2: "Speed Boost",
	#3: "Shield"
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn_new_item"):
		spawn_item()


func spawn_item():
	var new_item = item_scene.instantiate()
	#new_item.position = position
	var item_sprite = new_item.get_node("Item")
	item_sprite.frame = item_id - 1
	item_sprite.name = ITEM_NAMES.get(item_id)
	add_child(new_item)
	var mother = get_parent()
	new_item.reparent(mother)
