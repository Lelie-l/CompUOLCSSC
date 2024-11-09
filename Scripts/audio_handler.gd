extends Node

var music:float = 0.5
var sfx:float = 0.5

var audionode = preload("res://Scenes/AudioNode.tscn")

var audio_music = preload("res://Scenes/audio_music_player.tscn")

func _ready() -> void:
	set_music_volume(0.8)

func play(audioname:String, pitch_random:bool = false, volume:int=0,audio_variety:Array[String]=[], pitch:float=1):
	if sfx == 0: return
	var file_name = "res://Audio/" + audioname + ".wav"
	if audio_variety.size() >= 1:
		file_name = "res://Audio/" + audioname + "/" + audio_variety.pick_random() + ".wav"
	if !FileAccess.file_exists(file_name):
		pass
		#print("Audio name [" + file_name + "] does not exist")
	var node_instance = audionode.instantiate()
	node_instance.stream = load(file_name)
	node_instance.pitch_scale = pitch
	if pitch_random:
		node_instance.pitch_scale *= randf_range(0.9,1.1)
	node_instance.volume_db = volume + (sfx - 1)*(80+volume)/3
	add_child(node_instance)

func set_music_volume(volume:float):
	music = volume
	#$BGM.volume_db = volume + (music - 1)*(80+volume)/3
	#if music == 0:
		#$BGM.volume_db = -80
		#$BGM2.volume_db = -80
	

func add_music(music: AudioStream, vary_beginning:bool=false):
	var audio_instance = audio_music.instantiate()
	audio_instance.stream = music
	
	$Music.add_child(audio_instance)
	audio_instance.fade_in()
	
	if vary_beginning:
		audio_instance.seek(randf_range(0, music.get_length()))
	

func fade_music():
	for child in $Music.get_children():
		child.fade_out()

func damp_music(dampness:bool=true):
	for child in $Music.get_children():
		child.damp(dampness)
