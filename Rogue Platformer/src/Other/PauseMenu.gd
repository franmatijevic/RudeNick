extends Control

func _process(delta: float) -> void:
	if(get_tree().paused):
		if(Input.is_action_just_pressed("ui_accept")):
			get_tree().paused=false
		print("drek")
	else:
		pass
		#visible=false

func _on_Button_pressed() -> void:
	print("radi nesto")
	if(get_tree().paused):
		get_tree().paused=false
