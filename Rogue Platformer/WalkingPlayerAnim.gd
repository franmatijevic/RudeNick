extends Node2D

var speed:=65

func _ready() -> void:
	if(get_node("/root/Game").shotgun>0):
		get_node("Shotgun").visible=true

func _process(delta: float) -> void:
	global_position.x+=speed*delta
	
	if(global_position.x>288):
		queue_free()
