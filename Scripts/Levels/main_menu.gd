extends Control

@export var settings:Control

var cover_pos = []

var time:float = 0.0

signal started

func _ready() -> void:
	cover_pos.append($Cover1.position)
	cover_pos.append($Cover2.position)
	cover_pos.append($Cover3.position)
	cover_pos.append($Cover4.position)
	cover_pos.append($Cover5.position)

func play() -> void:
	if !Global.main_menu: return
	Global.main_menu = false
	Global.intro = true
	started.emit()
	$AnimationPlayer.play("play")

func _process(delta: float) -> void:
	time += delta
	$Title.position.y = sin(time)*10 + 100
	
	var mouse_pos = get_global_mouse_position() - Vector2(DisplayServer.screen_get_size())/2
	
	$Cover1.position = cover_pos[0] - mouse_pos * 0.01
	$Cover2.position = cover_pos[1] - mouse_pos * 0.021
	$Cover3.position = cover_pos[2] - mouse_pos * 0.0234
	$Cover4.position = cover_pos[3] - mouse_pos * 0.06
	$Cover5.position = cover_pos[4] - mouse_pos * 0.2

func _on_play_button_up() -> void:
	play()

func _on_settings_button_up() -> void:
	if is_instance_valid(settings):
		settings.show()


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	hide()
