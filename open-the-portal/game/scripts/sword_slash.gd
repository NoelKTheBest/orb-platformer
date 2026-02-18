extends Sprite2D

var sword
var slash_toggle = false

# Called when the node enters the scene tree for the first time.
func play_anim():
	var anim_name = ""
	if !slash_toggle:
		anim_name = "slash1"
	else:
		anim_name = "slash2"
	if !$AnimationPlayer.is_playing(): $AnimationPlayer.play(anim_name)
	slash_toggle = !slash_toggle
