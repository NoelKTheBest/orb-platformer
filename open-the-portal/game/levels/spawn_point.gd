extends Sprite2D

@export var floor_number: int = 0
@export var is_door: bool = false
## 0 - no state; 1 - patrol; 2 - guard
@export_range(0, 2, 1) var starting_entity_state: int = 0
