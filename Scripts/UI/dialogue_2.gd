extends dialogue

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
				$AnimationPlayer.play("fade_out")
				#Audio.fade_music()
				#Audio.add_music(load("res://Audio/Music/ExerciseHipHop.wav"), true)
		


func _on_player_pushup_won() -> void:
	Global.dialogue = true
	await get_tree().create_timer(1).timeout
	show()
	move_text()
