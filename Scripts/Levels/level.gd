extends Node2D

@export var camera:Camera2D
@export var player:Node2D
@export var redflash:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.node_parent = self
	

func _process(delta: float) -> void:
	pass


func _on_player_hit_signal() -> void:
	redflash.flash(.5)
	camera.shake(0.2,0.3)


func _on_area_2d_body_entered(body: Node2D) -> void:
	redflash.flash(.5)
	camera.shake(0.2,0.3)
	player.global_position = $Area2D/Marker2D.global_position


func _on_win_area_entered(area: Area2D) -> void:
	$CanvasLayer/ColorRect.show()
	$CanvasLayer/AnimationPlayer.play("fade_out")
