extends Sprite2D

var speed = 200

var time = 0
var destroyed = false

func _ready() -> void:
	speed = randi_range(400,1200)
	scale.x *= randf_range(0.8,1.2)
	scale.y *= randf_range(0.8,1.2)

func _process(delta: float) -> void:
	global_position.y -= delta*speed
	time += delta
	if time > 1 and !destroyed:
		queue_free()
		destroyed = true
