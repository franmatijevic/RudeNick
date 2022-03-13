extends KinematicBody2D


func destroy()->void:
	var wood=preload("res://src/Other/Woodpiece.tscn").instance()
	wood.position=position
	get_parent().add_child(wood)
	queue_free()
