@abstract extends ControlledEntity

var target_position: Vector2
var monitor_player_position = false
var player_position = Vector2.ZERO
var patrol_area = true
var camera_position := Vector2.ZERO
var sound_source_position := Vector2.ZERO
var heat_sensor_position := Vector2.ZERO
var nearest_door_position := Vector2.ZERO
var current_floor : int
var using_door: bool = false
var destination_floor: int
var listen_for_player_coords = false

func normalize_target_position(): return target_position.normalized()
