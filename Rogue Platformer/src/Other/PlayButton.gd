extends KinematicBody2D

var hover:=false


func _on_PlayButton_mouse_entered() -> void:
	hover=true

func _on_PlayButton_mouse_exited() -> void:
	hover=false

func _process(delta: float) -> void:
	if(hover):
		get_node("AnimatedSprite").animation="hover"
		if(Input.is_action_just_pressed("mouse_left")):
			get_parent().get_parent().level=0
			get_parent().get_parent().new_level()
	else:
		get_node("AnimatedSprite").animation="default"






