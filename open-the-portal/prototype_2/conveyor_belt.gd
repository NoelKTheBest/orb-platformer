extends Control

const DEBUG = true  # Set to false to disable all debug prints
const MIN_BOXES = 6  # Minimum slots always visible even if empty
const ITEM_TEXTURES = {
	1: preload("res://sprites/items/1.png"),
	2: preload("res://sprites/items/2.png"),
	3: preload("res://sprites/items/3.png"),
	4: preload("res://sprites/items/4.png"),
	5: preload("res://sprites/items/5.png"),
	6: preload("res://sprites/items/6.png"),
	7: preload("res://sprites/items/7.png"),
}

var inventory: Array[int] = [5, 0, 0, 0, 0, 0]  # 6 slots, 0 = empty

@onready var inventory_container: HBoxContainer = $Inventory

func _ready() -> void:
	if DEBUG:
		print("Inventory system initialized with ", MIN_BOXES, " minimum slots")
	update_visual()
	
	# Handle use_item input
	if not InputMap.has_action("use_item"):
		push_warning("Input action 'use_item' not found in Input Map!")

func add_item(item_id: int, _item_texture: Texture2D = null) -> bool:
	# Find first empty slot (value 0)
	var empty_index := -1
	for i in range(inventory.size()):
		if inventory[i] == 0:
			empty_index = i
			break

	# Use empty_index to set the item id (Check if inventory is not full)
	if empty_index != -1:
		inventory[empty_index] = item_id
		
		# Show pickup notification
		var item_name = ItemNameDictionary.ITEM_NAMES.get(item_id, "Unknown Item")
		show_pickup_notification(item_name)
		
		if DEBUG:
			print("Item ID ", item_id, " ('", item_name, "') added to slot ", empty_index, ". Inventory: ", inventory)
		update_visual()
		return true
	else:
		if DEBUG:
			print("Inventory full! Cannot add item ID ", item_id)
		return false

func use_item() -> bool:
	# Find first non-empty slot
	var first_item_index := -1
	for i in range(inventory.size()):
		if inventory[i] != 0:
			first_item_index = i
			break
	
	if first_item_index == -1:
		if DEBUG:
			print("No items to use!")
		return false
	
	# Use the first item (set to 0)
	inventory[first_item_index] = 0
	
	# Shift all items left to fill gap
	for i in range(first_item_index, inventory.size() - 1):
		inventory[i] = inventory[i + 1]
	inventory[inventory.size() - 1] = 0  # Last slot always empty
	
	if DEBUG:
		print("Used item from slot ", first_item_index, ". New inventory: ", inventory)
	
	update_visual()
	return true

func update_visual() -> void:
	for i in range(inventory.size()):
		var slot_node = inventory_container.get_child(i)  # Slot1, Slot2, etc.
		var item_rect: TextureRect = slot_node.get_node("Design1/Design2/Item")
		
		# Show slot if within minimum boxes or has item
		var should_show_slot := (i < MIN_BOXES) or (inventory[i] != 0)
		slot_node.visible = should_show_slot
		
		if inventory[i] != 0:
			# Load texture based on item ID
			var texture_path := "res://sprites/items/" + str(inventory[i]) + ".png"
			item_rect.texture = load(texture_path)
			item_rect.visible = true
		else:
			item_rect.texture = null  # Remove texture but keep TextureRect
			item_rect.visible = false

func get_slot_content(slot_index: int) -> int:
	if slot_index >= 0 and slot_index < inventory.size():
		return inventory[slot_index]
	return -1

func is_full() -> bool:
	for item in inventory:
		if item == 0:
			return false
	return true

func show_pickup_notification(item_name: String) -> void:
	var label = Label.new()
	label.text = "Picked up: " + item_name
	label.add_theme_color_override("font_color", Color.YELLOW)
	label.add_theme_font_size_override("font_size", 28)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	get_tree().root.add_child(label)
	label.position = Vector2(300, 150)
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 2.0).set_delay(1.0)
	tween.tween_callback(label.queue_free)


func advance_belt() -> void:
	var first_element = inventory[0]
	for i in range(inventory.size()):
		# If we are on the last index, set to first element if slot is not empty
		if i == inventory.size() - 1:
			inventory[i] = first_element if inventory[i] != 0 else 0
		else:
			# If the next slot is not empty, set current slot to the next element
			if inventory[i + 1] != 0:
				inventory[i] = inventory[i + 1]
			else: inventory[i] = first_element if inventory[i] != 0 else 0
	
	update_visual()
