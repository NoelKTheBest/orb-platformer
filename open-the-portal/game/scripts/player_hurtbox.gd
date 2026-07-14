extends Area2D

signal player_was_hit(collision_vector)
@onready var damage_taken_timer: Timer = $"../DamageTakenTimer"

var collision_point


func _physics_process(_delta: float) -> void:
	var areas = get_overlapping_areas()
	#print(areas)
	#print(get_overlapping_bodies())
	if has_overlapping_areas(): 
		# should the bullets not have knockback? or should every attack have knockback. it makes coming up with an idea afterwards easy because you know exactly how the hit will behave and in this game every hit should do the same thing?
		collision_point = areas[0].get_parent().position
		
		if areas[0].get_parent().is_in_group("Enemy Orbs"): collision_point = areas[0].get_parent().get_parent().position
	
	for area in areas:
		if area.visible and damage_taken_timer.time_left == 0.0:
			player_was_hit.emit(((collision_point - get_parent().position) * -1).normalized())
			damage_taken_timer.start()
			break
