extends Node

var main_menu = true
var intro = false
var dialogue = false
var qte = false

var node_parent = null
var player = null
var camera = null

# Settings
var screen_shake:bool = true

func instance_node(node, parent, position=Vector2.ZERO):
	var node_instance = node.instantiate()
	parent.add_child(node_instance)
	if position != Vector2.ZERO:
		node_instance.global_position = position
	return node_instance
