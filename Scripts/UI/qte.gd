extends Node2D

var time = 0

var correct:bool = false

var started = false
var pressed = false

var curr_diff = -1

var speed = 1

var mode = 0

signal correct_answer
signal wrong

signal won

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !started: return
	time += delta
	
	if !pressed:
		if mode == 0:
			$Arrow.position.x = sin(time*PI*speed)*11
		elif mode == 1:
			$Arrow.position.x = sin(time*PI*speed)**4*22-11
	
	if Input.is_action_just_pressed("space"):
		pressed = true
		if correct:
			correct_answer.emit()
		else:
			wrong.emit()


func _on_arrow_area_entered(area: Area2D) -> void:
	correct = true


func _on_arrow_area_exited(area: Area2D) -> void:
	correct = false

func wrong_anim():
	$AnimationPlayer.play("wrong")
func correct_anim():
	$AnimationPlayer.play("correct")

func load_in():
	curr_diff = -1
	speed = 1
	show()
	$AnimationPlayer.play("fade_in")

func start(increment:bool=false):
	if curr_diff >= 9:
		won.emit()
		$AnimationPlayer.play("fade_out")
		started = false
		Global.qte = false
		return
	if increment:
		curr_diff += 1
		if mode == 0:
			speed += 0.08
		elif mode == 1:
			speed += 0.02
	pressed = false
	started = true
	$Target.scale.x = 6 - curr_diff/2.0
	$Target.position.x = randi_range(-5-curr_diff/2.0,5+curr_diff/2.0)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_in":
		start(true)
