extends Control

var last:String=""

var dead:=false

var choice:int=0
#restart 0
#help 1
#quit 2
var dead_setup:=false


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(dead):
		if(!dead_setup):
			setup()
		else:
			if(Input.is_action_just_pressed("down")):
				choice+=1
				if(choice==3):
					choice=0
			if(Input.is_action_just_pressed("up")):
				choice-=1
				if(choice==-1):
					choice=2
			if(choice==0):
				get_node("ResetHover").visible=true
				get_node("Help").visible=false
				get_node("Quit").visible=false
			elif(choice==1):
				get_node("ResetHover").visible=false
				get_node("Help").visible=true
				get_node("Quit").visible=false
			else:
				get_node("ResetHover").visible=false
				get_node("Help").visible=false
				get_node("Quit").visible=true
			if(Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("action") or Input.is_action_just_pressed("ui_accept")):
				if(choice==0):
					get_node("/root/Game").restart()
					get_node("/root/Game").can_pause=true
				elif(choice==1):
					pass
				else:
					#get_node("/root/Game").back_to_main_menu()
					get_tree().reload_current_scene()



func setup()->void:
	get_node("GameOver").visible=true
	get_node("GameOver").frame=0
	yield(get_tree().create_timer(0.7), "timeout")
	dead_setup=true
	get_node("ResetHover").visible=true
	get_node("Time_whole").visible=true
	get_node("Killed").visible=true
	get_node("LevelDead").visible=true



func print_something(text: String)->void:
	last=text
	get_node("DialogText").text=text
	get_node("DialogText").visible_characters=0
	get_node("DialogBox").visible=true
	get_node("DialogText").visible=true
	for i in range(40):
		if(last!=text):
			break
		get_node("DialogText").visible_characters=i
		yield(get_tree().create_timer(0.05), "timeout")
	yield(get_tree().create_timer(2), "timeout")
	if(last==text):
		get_node("DialogBox").visible=false
		get_node("DialogText").visible=false
