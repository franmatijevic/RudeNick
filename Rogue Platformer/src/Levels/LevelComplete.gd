extends Node2D

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("buy")):
		get_parent().new_level()
