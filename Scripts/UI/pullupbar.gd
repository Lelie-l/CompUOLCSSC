extends TextureProgressBar
signal upgrade_pull_up
signal pullup_fail
signal pullup_won

var started = false
var number = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = 200
	value = 0

func start():
	value = 100
	started = true

func _process(delta: float) -> void:
	if !started: return
	value -= delta*100
	if Input.is_action_just_pressed("space"):
		value+=16
	if value == max_value:
		value = 100
		number += 1
		if number >= 6:
			emit_signal("pullup_won")
		emit_signal("upgrade_pull_up")
	if value == 0:
		value = 100
		emit_signal("pullup_fail")
