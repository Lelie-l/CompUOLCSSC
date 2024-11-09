class_name dialogue
extends Control

@export var list:Array[String]
var curr_index = 0

@onready var label = $ColorRect/Label

var done = false


func move_text():
	var text = list[curr_index]
	
	done = false
	label.add_text(text)
	await label.done
	done = true



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	hide()
