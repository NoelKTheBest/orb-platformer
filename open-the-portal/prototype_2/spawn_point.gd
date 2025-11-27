extends Node2D

#signal _countdown_finished

var enemy_scene = preload("res://prototype_2/prototype_2_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = " "


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func play_countdown_timer():
	$AnimationPlayer.play("countdown")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	#countdown_finished.emit()
	add_child(enemy_scene.instantiate())
