extends Node2D

func remove()->void:
	var time_in_seconds = 0.2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	if($Bone.is_colliding()):
		queue_free()

func _ready() -> void:
	remove()
