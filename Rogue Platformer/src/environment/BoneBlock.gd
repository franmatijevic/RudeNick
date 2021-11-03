extends Node2D

func _on_Area2D_area_entered(area: Area2D) -> void:
	#get_node("CollisionShape2D").disabled = true
	queue_free()
