extends KinematicBody2D




func _on_DetectPlayer_body_entered(body: Node) -> void:
	get_node("E").visible=true


func _on_DetectPlayer_body_exited(body: Node) -> void:
	get_node("E").visible=false
