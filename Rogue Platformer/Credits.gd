extends Node2D

var click:=false

var time:float=0.2

func _ready() -> void:
	get_node("Music").play()

func _process(delta: float) -> void:
	time+=delta
	if(time>0.5):
		time=0.0
		get_node("Thank").visible=!(get_node("Thank").visible)
	
	if(Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("buy")):
		if(click==true):
			skip()
		else:
			click=true

func skip()->void:
	get_node("Music").stop()
	yield(get_tree().create_timer(1), "timeout")
	get_node("/root/Game").credits()
