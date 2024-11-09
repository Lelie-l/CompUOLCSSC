extends CharacterBody2D

# Exports
@export var max_speed:int = 200
@export var coyote_time :float= 0.15
@export var acceleration:float = 16
@export var max_health:int = 100
@export var text_progress_bar: TextureProgressBar

var correct_particles = preload("res://Scenes/Decor/particles.tscn")

var lvlup = preload("res://Scenes/Decor/lvl_up.tscn")

# Movement Variables
var dir := Vector2.ZERO
var speed:float = 200
var time_from_land = 0
var jump_time = 0

var animed=  false

var intro:bool = true
var intro_start:bool = false
var intro_end:bool = false
var white_line = preload("res://Scenes/Decor/whiteline.tscn")

var pushing_up:bool = false

var squat_unlocked = true
var squatting = false

var pullup_unlocked = false
var pulling_up:bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var on_cliff:bool = false
var can_climb:bool = false

# Player Properties
var health:int = 100

@export var target_pullup:Node2D

signal just_hit
signal intro_up
signal pushup_won
signal squat_won
signal pullup_won

signal hit_signal

func _ready() -> void:
	# Sets Important Variable Values
	Global.win = false
	Global.player = self
	speed = max_speed
	health = max_health

func _physics_process(delta: float) -> void:
	if intro or Global.dialogue or Global.win: return
	if intro_start:
		$Sprite.frame = 0
		$Sprite.animation = "fall"
		velocity =Vector2(0,1000)
		move_and_slide()
		Global.instance_node(white_line, Global.node_parent, global_position + Vector2(randi_range(-600,600), randi_range(-200,600)))
		if is_on_floor():
			intro_start = false
			intro_end = true
			Global.node_parent.camera.shake(0.2,0.3)
			Audio.play("landing")
		return
	if intro_end:
		$Sprite.play("fall")
		if $Sprite.frame == 22:
			intro_end = false
			Global.dialogue = true
			intro_up.emit()
			animed = true
			$QTE.mode = 0
			$Combo.fade_in()
			Audio.play("pushup_back_up")
		return
	if pushing_up:
		if animed: 
			$Sprite.play("pushup")
			animed = false
		return
	if squatting:
		if animed: 
			$Sprite.play("squat")
			animed = false
		return
	if pulling_up:
		if animed: 
			global_position = target_pullup.global_position
			$Sprite.play("pullup")
			animed = false
		return

	
	if squat_unlocked:
		speed = max_speed * 2
	else:
		speed = max_speed
	
	# Handles Direction and Player Input
	var target_dir = Vector2.ZERO
	target_dir.x = Input.get_axis("left", "right")
	dir.x = move_toward(dir.x, target_dir.x, delta*acceleration)
	
	if is_on_floor():
		if target_dir.x == 0:
			$Sprite.play("idle")
		else:
			if squat_unlocked:
				$Sprite.play("run")
			else:
				$Sprite.play("walk")
	
	#print(is_on_floor(), ", ", time_from_land, ", ", coyote_time)
	if is_on_ceiling():
		dir.y = 0
	if is_on_floor():
		jump_time = 0
		time_from_land = 0
		dir.y = 0
	else:
		time_from_land += delta
		dir.y += 2400*delta
	
	if Input.is_action_pressed("space"):
		if time_from_land < coyote_time:
			jump_time += delta*10
			jump_time = min(jump_time, 1)
			var squat_jump = 1 + int(squat_unlocked) * 0.2
			dir.y -= (340 - 340*(jump_time)) * squat_jump
			$Sprite.play("jump")
	
	#yaser252
	# Handles Horizontal Sprite Flipping
	if dir.x < 0:
		$Sprite.flip_h = false
	elif dir.x > 0:
		$Sprite.flip_h = true
	
	if on_cliff:
		if can_climb:
			$Sprite.animation = "climb"
			if Input.is_action_pressed("up"):
				dir.y = -200
				$Sprite.play("climb")
			elif Input.is_action_pressed("down"):
				dir.y = 200
				$Sprite.play_backwards("climb")
			else:
				dir.y = 0
				$Sprite.pause()
	# Handles Final Movement
	velocity = Vector2(dir.x * speed, dir.y)
	move_and_slide()
	
			
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider().is_in_group("box"):
			c.get_collider().push((-c.get_normal() * (speed/2)).x)

func hit(dmg:int):
	health -= dmg
	just_hit.emit()


func _on_intro_start() -> void:
	intro = false
	intro_start = true


func _on_dialogue_pushup_start() -> void:
	pushing_up = true
	$QTE.load_in()


func _on_qte_correct_answer() -> void:
	if pushing_up:
		$Sprite.play("pushup")
		$Sprite.frame = 2
	elif squatting:
		$Sprite.play("squat")
		$Sprite.frame = 1
	elif pulling_up:
		$Sprite.play("pullup")
		$Sprite.frame = 1
	$QTE.correct_anim()
	$QTE.start(true)
	$Combo.inc()
	Audio.play("qtesuccess")
	Global.instance_node(correct_particles, Global.node_parent, $QTE/Arrow.global_position)


func _on_qte_wrong() -> void:
	$QTE.wrong_anim()
	$QTE.start()
	hit_signal.emit()
	$Combo.drop()
	Audio.play("fail_pushup")


func _on_qte_won() -> void:
	Global.instance_node(lvlup, Global.node_parent, global_position+Vector2(0,-30))
	Audio.play("powerUp")
	if pushing_up:
		pushup_won.emit()
		pushing_up = false
	elif squatting:
		squat_won.emit()
		squatting = false
	elif pulling_up:
		pullup_won.emit()
		pulling_up = false
	$Combo.fade_out()
	Audio.fade_music()
	Audio.add_music(load("res://Audio/Music/MainMenuOST.wav"), true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	dir.y = 0



func _on_dialogue_3_squat_start() -> void:
	if !squat_unlocked:
		squatting = true
		$QTE.load_in()
		Global.qte = true
		$QTE.mode = 1
		animed = true
		squat_unlocked = true
		$Combo.fade_in()


func _on_dialogue_5_pullup_start() -> void:
	if !pullup_unlocked:
		pulling_up = true
		#$QTE.load_in()
		Global.qte = true
		#$QTE.mode = 1
		animed = true
		pullup_unlocked = true
		$Combo.fade_in()
		$pullupbar.start()
		$pullupbar.show()
		can_climb = true

func _on_CliffWall_body_entered(body:Node2D) -> void:
	if  self == body:
		on_cliff = true
func _on_CliffWall_body_exited(body:Node2D) -> void:
	if self == body:
		on_cliff = true


func _on_pullupbar_upgrade_pull_up() -> void:
	$Sprite.play("pullup")
	$Sprite.frame = 1
	$Combo.inc()
	Audio.play("qtesuccess")
	Global.instance_node(correct_particles, Global.node_parent, $QTE/Arrow.global_position)


func _on_pullupbar_pullup_fail() -> void:
	hit_signal.emit()
	$Combo.drop()
	Audio.play("fail_pushup")


func _on_pullupbar_pullup_won() -> void:
	Global.instance_node(lvlup, Global.node_parent, global_position+Vector2(0,-30))
	Audio.play("powerUp")
	pullup_won.emit()
	pulling_up = false
	$pullupbar.started = false
	can_climb = true
	$Combo.fade_out()
	$pullupbar.hide()
	Audio.fade_music()
	Audio.add_music(load("res://Audio/Music/MainMenuOST.wav"), true)


func _on_area_2d_area_entered(area: Area2D) -> void:
	on_cliff = true
	print("YUES")


func _on_area_2d_area_exited(area: Area2D) -> void:
	on_cliff = false
