extends Node2D


func _ready() -> void:
	remove()

func remove()->void:
	var time_in_seconds = 0.6
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	queue_free()

