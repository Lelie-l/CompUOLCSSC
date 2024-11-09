extends Node2D

var combo = 0

var fading_out = false

func fade_out():
	fading_out = true
	$AnimationPlayer.play("fade_out")

func inc():
	combo += 1
	if combo < 2:
		hide()
	else:
		show()
		Audio.play("bell",false,15,[],0.8+combo*0.05)
	$Node2D/Label.text = str(combo) + "X Combo"
	scale = Vector2(1,1) * (1+combo*0.1)
	$Node2D.modulate.b = 1-combo*0.05
	if !fading_out:
		$AnimationPlayer.play("flash")

func drop():
	combo = 0
	hide()
