extends Node2D

var x = 1
var destroyed = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	x -= delta*0.5
	global_position.y -= delta*x*30
	modulate.a = x
	if x < 0 and !destroyed:
		destroyed = true
		queue_free()
