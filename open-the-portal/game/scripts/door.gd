extends Polygon2D

signal _player_can_use_door

enum entrance_mode {WALK, TELEPORT, ONE_WAY}

var show_label
var player_can_use_door
## 0 for WALK; 1 for TELEPORT; 2 for ONE_WAY
var entrance_form = entrance_mode.WALK
var destination_floor: int

@export var door: Node2D
@export var goes_down: bool = false
@export var floor_number: int = 0
@export var is_one_way: bool = false
@export var player_node_name: String = "Player"

@onready var label: Label = $Label


func _ready() -> void:
	if is_one_way: entrance_form = entrance_mode.ONE_WAY
	if door: destination_floor = door.floor_number


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var bodies = $Area2D.get_overlapping_bodies()
	
	# This only runs if the door's area has detectable physics bodies
	if bodies.size() > 0:
		for b in bodies:
			if b.name == player_node_name:
				if show_label:
					label.visible = true
					if door and Input.is_action_just_pressed("use_door"):
						b.position = door.position
			else:
				label.visible = false
			
			if b.is_in_group("Enemy"):
				teleport_body(b)
	elif bodies.size() == 0:
		if label.visible: label.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		teleport_body(body)


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		if entrance_form == entrance_mode.TELEPORT:
			entrance_form = entrance_mode.WALK


func teleport_body(body: Node2D):
	if door and entrance_form == entrance_mode.WALK and body.using_door and body.destination_floor == destination_floor:
		door.entrance_form = entrance_mode.TELEPORT
		body.position = door.position
