extends Node2D

func _ready() -> void:
	if($Bone.is_colliding()):
		queue_free()
