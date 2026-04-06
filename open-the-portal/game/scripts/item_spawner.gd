extends Polygon2D

var item_scene : PackedScene = preload("res://game/scenes/item.tscn")
#@export var item_name : String
@export var item_id : int


func spawn_item():
	var new_item = item_scene.instantiate()
	#new_item.position = position
	var item_sprite = new_item.get_node("Sprite2D")
	var item_name = ItemNameDictionary.ITEM_NAMES.get(item_id)
	new_item.name = item_name
	new_item.id = item_id
	new_item.item_name = item_name
	item_sprite.frame = item_id - 1
	add_child(new_item)
	var mother = get_parent()
	new_item.reparent(mother)


func random_roll_item():
	var rng = RandomNumberGenerator.new()
	var random_num = rng.randi_range(0, 70)
	if random_num >= 0 and random_num <= 10:
		return(1)
	elif random_num > 10 and random_num <= 20:
		return(2)
	elif random_num > 20 and random_num <= 30:
		return(3)
	elif random_num > 30 and random_num <= 40:
		return(4)
	elif random_num > 40 and random_num <= 50:
		return(5)
	elif random_num > 50 and random_num <= 60:
		return(6)
	elif random_num > 60 and random_num <= 70:
		return(7)


func _on_timer_timeout() -> void:
	item_id = random_roll_item()
	spawn_item()
