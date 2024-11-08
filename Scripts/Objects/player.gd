extends CharacterBody2D

# Exports
@export var max_speed:int = 200
@export var coyote_time :float= 0.15
@export var acceleration:float = 16
@export var max_health:int = 100

# Movement Variables
var dir := Vector2.ZERO
var speed:float = 200
var time_from_land = 0
var jump_time = 0

var intro:bool = true
var intro_start:bool = false
var intro_end:bool = false
var white_line = preload("res://Scenes/Decor/whiteline.tscn")

# Player Properties
var health:int = 100

signal just_hit

func _ready() -> void:
	# Sets Important Variable Values
	Global.player = self
	speed = max_speed
	health = max_health

func _physics_process(delta: float) -> void:
	if intro: return
	if intro_start:
		$Sprite.frame = 0
		$Sprite.animation = "fall"
		velocity =Vector2(0,1000)
		move_and_slide()
		Global.instance_node(white_line, Global.node_parent, global_position + Vector2(randi_range(-600,600), randi_range(-200,600)))
		if is_on_floor():
			intro_start = false
			intro_end = true
		return
	if intro_end:
		$Sprite.play("fall")
		if $Sprite.frame == 22:
			intro_end = false
		return
	
	# Handles Direction and Player Input
	var target_dir = Vector2.ZERO
	target_dir.x = Input.get_axis("left", "right")
	dir.x = move_toward(dir.x, target_dir.x, delta*acceleration)
	
	if is_on_floor():
		if target_dir.x == 0:
			$Sprite.play("idle")
		else:
			$Sprite.play("walk")
	
	#print(is_on_floor(), ", ", time_from_land, ", ", coyote_time)
	if is_on_floor():
		time_from_land = 0
		dir.y = 0
	else:
		time_from_land += delta
		dir.y += 2400*delta
	
	if Input.is_action_pressed("space"):
		if time_from_land < coyote_time:
			jump_time += delta*10
			jump_time = min(jump_time, 1)
			dir.y -= 340 - 340*(jump_time)
			$Sprite.play("jump")
		else:
			jump_time = 0
	else:
		jump_time = 0
	
	#yaser252
	# Handles Horizontal Sprite Flipping
	if dir.x < 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	
	# Handles Final Movement
	velocity = Vector2(dir.x * speed, dir.y)
	move_and_slide()

func hit(dmg:int):
	health -= dmg
	just_hit.emit()


func _on_intro_start() -> void:
	intro = false
	intro_start = true
