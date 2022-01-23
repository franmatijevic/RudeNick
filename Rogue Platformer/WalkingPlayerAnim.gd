extends Node2D

var speed:=65

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	global_position.x+=speed*delta
	
	if(global_position.x>288):
		queue_free()
