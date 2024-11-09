extends Control

@export var list:Array[String]
var curr_index = 0

@onready var label = $ColorRect/Label

var done = false

signal pushup_start

func move_text():
	var text = list[curr_index]
	
	done = false
	label.add_text(text)
	await label.done
	done = true
	


func _process(delta: float) -> void:
	if done:
		if Input.is_action_just_pressed("space"):
			done = false
			
			if curr_index < list.size()-1:
				curr_index += 1
				await get_tree().create_timer(0.01).timeout
				move_text()
			else:
				Global.dialogue = false
				Global.qte = true
				$AnimationPlayer.play("fade_out")
				pushup_start.emit()
				Audio.fade_music()
				Audio.add_music(load("res://Audio/Music/ExerciseHipHop.wav"), true)
		

func _on_player_intro_up() -> void:
	show()
	move_text()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hide()
