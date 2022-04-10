extends KinematicBody2D


func destroy()->void:
	var boom=preload("res://src/Other/Expolsion.tscn").instance()
	boom.position=position
	boom.get_node("BlockDMG/CollisionShape2D").shape.radius=30.0
	boom.get_node("DetectBoss/CollisionShape2D").shape.radius=30.0
	boom.get_node("KillBeings/CollisionShape2D").shape.radius=30.0
	boom.get_node("AnimatedSprite").scale.x=1.5
	boom.get_node("AnimatedSprite").scale.y=1.5
	get_parent().add_child(boom)
	queue_free()

func _on_Whip_area_entered(area: Area2D) -> void:
	destroy()
