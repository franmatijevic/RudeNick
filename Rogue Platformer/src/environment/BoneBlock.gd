extends Node2D

func _ready() -> void:
	randomize()
	if(randi()%5==0):
		get_node("BoneBlock2").queue_free()
	else:
		get_node("BoneBlock1").queue_free()

func _on_Area2D_area_entered(area: Area2D) -> void:
	#get_node("CollisionShape2D").disabled = true
	queue_free()
