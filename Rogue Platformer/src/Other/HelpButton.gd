extends KinematicBody2D

var hover:=false

func _on_HelpButton_mouse_entered() -> void:
	hover=true

func _on_HelpButton_mouse_exited() -> void:
	hover=false

func _process(delta: float) -> void:
	if(hover):
		get_node("AnimatedSprite").animation="hover"
		if(Input.is_action_just_pressed("mouse_left")):
			get_parent().call_help()
	else:
		get_node("AnimatedSprite").animation="default"



