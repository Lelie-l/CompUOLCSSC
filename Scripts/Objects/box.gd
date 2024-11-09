extends CharacterBody2D

var dir = Vector2.ZERO

func _physics_process(delta: float) -> void:
	dir.x = move_toward(dir.x,0,delta*400)
	if is_on_ceiling():
		dir.y = 0
	if is_on_floor():
		dir.y = 0
	else:
		dir.y += 2400*delta
	
	velocity = dir
	move_and_slide()

func push(dir_to_x):
	dir.x = dir_to_x
