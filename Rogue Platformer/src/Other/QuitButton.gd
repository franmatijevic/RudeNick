extends KinematicBody2D

var hover:=false

func _on_QuitButton_mouse_entered() -> void:
	hover=true

func _on_QuitButton_mouse_exited() -> void:
	hover=false


func _process(delta: float) -> void:
	if(hover):
		get_node("AnimatedSprite").animation="hover"
		if(Input.is_action_just_pressed("mouse_left")):
			get_tree().quit()
	else:
		get_node("AnimatedSprite").animation="default"




