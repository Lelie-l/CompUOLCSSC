extends CharacterBody2D

var time = 0
var dir = Vector2.ZERO
@export var speed = 150
@export var freq = PI

func _physics_process(delta: float) -> void:
	dir = Vector2.ZERO
	time += delta
	
	velocity.x = sin(time*freq)*speed
	
	move_and_slide()
