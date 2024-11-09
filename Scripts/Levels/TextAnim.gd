extends Label

@export var keyboard:bool = false
@export_multiline var text_to = ""

var destroying:bool = false
var destroyed:bool = false
var num:int = 0
signal done

func _process(_delta):
	if destroying:
		modulate.a -= _delta
		if modulate.a <= 0 and !destroyed:
			queue_free()
			destroyed = true
		return
	if text_to.length() > 0:
		if Input.is_action_just_pressed("space"):
			text += text_to
			text_to = ""
			done.emit()
			return
		text += text_to.left(1)
		num += 1
		if num % 4 == 0:
			if keyboard:
				Audio.play("Keyboard", true, 15, ["1","2","3","4"])
			else:
				Audio.play("Speach", true, 15, ["Randall1","Randall2","Randall3","Randall4"])
		text_to = text_to.erase(0,1)
		if text_to.length() == 0:
			done.emit()

func add_text(text_set):
	text = ""
	text_to = text_set

func destroy():
	destroying = true
