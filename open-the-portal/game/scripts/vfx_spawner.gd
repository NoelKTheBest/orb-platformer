extends Node

var sprite_fr = preload("res://game/game_rss/hit_impact.tres")

func set_player(position: Vector2, sprite_frames: SpriteFrames = null):
	var new_animation = AnimatedSprite2D.new()
	new_animation.sprite_frames = sprite_fr
	new_animation.position = position
	new_animation.set_script(load("res://game/standard_vfx.gd"))
	get_tree().root.add_child(new_animation)
