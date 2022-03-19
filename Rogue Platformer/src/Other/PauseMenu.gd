extends Control

var is_paused = false setget set_is_paused
var pause:=false

func _unhandled_input(event):
	pass

func _process(delta: float) -> void:
	pass
	#if (Input.is_action_pressed("pause")):
	#	get_tree().paused = true
	#	if(!pause): pause=true
	#	else: pause=false
	#if(pause):
	#	get_tree().paused = true
	#else:
	#	get_tree().paused = false


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_Button_pressed() -> void:
	print("radi nesto")
	self.is_paused = false
