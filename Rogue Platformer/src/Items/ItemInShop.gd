extends Node2D


func _on_DetectPlayer_body_exited(body: Node) -> void:
	get_node("E").visible=false
	get_node("Text").visible=false

func _on_DetectPlayer_body_entered(body: Node) -> void:
	get_node("E").visible=true
	get_node("Text").visible=true

func _physics_process(delta: float) -> void:
	if(get_node("E").visible==true):
		if(Input.is_action_just_pressed("buy")):
			get_parent().get_parent().get_mad()
			queue_free()
