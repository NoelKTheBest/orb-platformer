extends Node


const audio_stream_names = {
	1: "soft impact",
	2: "hard impact"
}

func set_player(position: Vector2, audioStreamID: int):
	var new_stream = AudioStreamPlayer2D.new()
	var stream = load("res://audio/" + audio_stream_names[audioStreamID] + ".wav")
	new_stream.stream = stream
	new_stream.position = position
	new_stream.set_script(load("res://game/standard_sfx.gd"))
	get_tree().root.add_child(new_stream)
