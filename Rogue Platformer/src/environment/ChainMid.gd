extends Node2D


func _physics_process(delta: float) -> void:
	if(!$Up.is_colliding()):
		queue_free()
