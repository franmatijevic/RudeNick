extends Node2D

var lenght=0.6

func _ready() -> void:
	remove()


func remove()->void:
	yield(get_tree().create_timer(lenght), "timeout")
	queue_free()
