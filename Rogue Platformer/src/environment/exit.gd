extends KinematicBody2D


func _ready() -> void:
	if(get_node("/root/Game/World").temple):
		get_node("DungeonDoors").visible=true
		get_node("Entrance").visible=false


func _on_DetectPlayer_body_entered(body: Node) -> void:
	get_node("E").visible=true

func _on_DetectPlayer_body_exited(body: Node) -> void:
	get_node("E").visible=false
