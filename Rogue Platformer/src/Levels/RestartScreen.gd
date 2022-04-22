extends Node2D


func _ready() -> void:
	wait()

func wait()->void:
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("/root/Game").new_level()
