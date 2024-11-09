extends Label


var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	modulate.a = 0.5 + sin(time * PI)*0.25
