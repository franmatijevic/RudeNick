extends Node2D

var click:=true

var time:float=0.2

var volume_down:=false

func _ready() -> void:
	get_node("Music").play()

func _process(delta: float) -> void:
	if(volume_down):
		get_node("Music").volume_db-=15*delta
	
	time+=delta
	if(time>57):
		volume_down=true
	if(time>59):
		skip()
	
	get_node("Text").global_position.y-=75*delta
	
	if(Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("buy")):
		if(click==true):
			skip()
		else:
			click=true

func skip()->void:
	get_node("Music").stop()
	yield(get_tree().create_timer(1), "timeout")
	get_node("/root/Game").credits()
