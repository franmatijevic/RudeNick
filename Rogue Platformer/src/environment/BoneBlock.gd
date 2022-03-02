extends Node2D

func _ready() -> void:
	randomize()
	if(randi()%5==0):
		get_node("BoneBlock2").queue_free()
	else:
		get_node("BoneBlock1").queue_free()

func _on_Area2D_area_entered(area: Area2D) -> void:
	var blood=preload("res://src/Other/Bones.tscn").instance()
	blood.global_position=global_position
	get_parent().get_parent().add_child(blood)
	queue_free()
