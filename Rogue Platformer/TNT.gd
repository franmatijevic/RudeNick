extends KinematicBody2D


func destroy()->void:
	var boom=preload("res://src/Other/Expolsion.tscn").instance()
	boom.position=position
	get_parent().add_child(boom)
	queue_free()

func _on_Whip_area_entered(area: Area2D) -> void:
	destroy()
