extends Node

var audio_files

const audio_stream_names = {
	1: "soft impact",
	2: "hard impact"
}

const audio_stream_lib_names = {
	0: "bass drums HML",
	1: "blarg1",
	2: "borg1",
	3: "daaaa1",
	4: "deep bass drum 3",
	5: "heavy bd",
	6: "lowbeat1",
	7: "lowbuzz",
	8: "metal ride o4c or o5c",
	9: "openhat3 metal",
	10: "rimshot #1 o3c",
	11: "snare4-808 type-02",
	12: "ting1",
	13: "ting2",
	14: "wind_high",
	15: "wind_low2",
	16: "wind_low",
	17: "zang1",
	18: "zing1",
	19: "zorg1",
	20: "hard impact"
}


func _ready() -> void:
	audio_files = ResourceLoader.list_directory("res://rss/audio/sfx/")
	print(audio_files)


func set_player(position: Vector2, audioStreamID: int):
	var new_stream = AudioStreamPlayer2D.new()
	var stream = load("res://rss/audio/bc wav files/" + audio_stream_lib_names[audioStreamID] + ".wav")
	new_stream.stream = stream
	new_stream.position = position
	new_stream.set_script(load("res://game/scripts/standard_sfx.gd"))
	get_tree().current_scene.add_child(new_stream)
