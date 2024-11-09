extends AudioStreamPlayer

const VOLUME_TO_REACH:int = 0
const FADE_IN_TIME:float = 2
const FADE_OUT_TIME:float = 2.0

const DAMP_DB:int = -15

var fading_in = false
var fading_out = false

var volume:float = 0


func _ready() -> void:
	volume = volume_db

func _process(delta: float) -> void:
	if fading_in or fading_out: return
	volume_db = volume + (Audio.music - 1)*(80+volume)/3
	if Audio.music == 0:
			volume_db = -80

func fade_in():
	if fading_in: return
	fading_in = true
	while volume_db < VOLUME_TO_REACH:
		volume_db += 1/FADE_IN_TIME * get_process_delta_time() * (VOLUME_TO_REACH+80)
		await get_tree().process_frame
		if volume_db > VOLUME_TO_REACH:
			volume_db = VOLUME_TO_REACH
	fading_in = false

func fade_out():
	if fading_out: return
	fading_out = true
	while volume_db > -80:
		volume_db -= 1/FADE_OUT_TIME * get_process_delta_time() * (VOLUME_TO_REACH+80)
		await get_tree().process_frame
		if volume_db < -80:
			volume_db = -80
	fading_out = false
	queue_free()

func damp(dampness:bool):
	if dampness:
		while volume_db > DAMP_DB:
			volume_db -= get_process_delta_time() * (DAMP_DB+80)
			await get_tree().process_frame
			if volume_db < DAMP_DB:
				volume_db = DAMP_DB
	else:
		while volume_db < VOLUME_TO_REACH:
			volume_db += 1/FADE_IN_TIME * get_process_delta_time() * (VOLUME_TO_REACH-DAMP_DB)
			await get_tree().process_frame
			if volume_db > VOLUME_TO_REACH:
				volume_db = VOLUME_TO_REACH
