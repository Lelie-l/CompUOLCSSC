extends ColorRect

var label = preload("res://Scenes/UI/TextAnim.tscn")
@export var list:Array[String]
var done:bool = false

var started = false

signal start

func _on_main_menu_started() -> void:
	await get_tree().create_timer(2).timeout
	for i in list:
		var t_node = Global.instance_node(label, self)
		t_node.add_text(i)
		await t_node.done
	done = true
	$AnimationPlayer.play("continue")

func _process(delta: float) -> void:
	if done and !started:
		if Input.is_action_just_pressed("space"):
			start.emit()
			started = true
			$AnimationPlayer.play("fade_out")
			await get_tree().create_timer(1).timeout
			hide()
		
