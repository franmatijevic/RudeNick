extends Control

var last:String=""

var dead:=false

var choice:int=0
#restart 0
#help 1
#quit 2
#music 3
var dead_setup:=false

var help:=false
var help_choice:int=0
#left 0
#right 1
#back 2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if(dead):
		get_node("MusicButton").visible=true
		if(!dead_setup):
			setup()
		elif(!help):
			if(get_node("GameOver").frame==8):
				pass
				#get_node("Time_whole").visible=true
				#get_node("Killed").visible=true
				#get_node("LevelDead").visible=true
				#get_node("Portrait").visible=true
			
			if(Input.is_action_just_pressed("down")):
				if(get_node("GameOver").visible==true):
					get_node("Click").play()
				choice+=1
				if(choice==4):
					choice=0
			if(Input.is_action_just_pressed("up")):
				if(get_node("GameOver").visible==true):
					get_node("Click").play()
				choice-=1
				if(choice==-1):
					choice=3
			if(choice==0):
				get_node("ResetHover").visible=true
				get_node("Help").visible=false
				get_node("Quit").visible=false
				if(get_node("/root/Game").music):
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
				else:
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
			elif(choice==1):
				get_node("ResetHover").visible=false
				get_node("Help").visible=true
				get_node("Quit").visible=false
				if(get_node("/root/Game").music):
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
				else:
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
			elif(choice==2):
				get_node("ResetHover").visible=false
				get_node("Help").visible=false
				get_node("Quit").visible=true
				if(get_node("/root/Game").music):
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
				else:
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
			else:
				get_node("ResetHover").visible=false
				get_node("Help").visible=false
				get_node("Quit").visible=false
				if(get_node("/root/Game").music):
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_hover.png")
				else:
					get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted_hover.png")
			if(Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("action") or Input.is_action_just_pressed("ui_accept")):
				if(choice==0):
					get_node("/root/Game").restart()
					get_node("/root/Game").can_pause=true
				elif(choice==1):
					help_setup()
				elif(choice==2):
					get_node("/root/Game").back_to_main_menu()
					#get_tree().reload_current_scene()
				else:
					get_node("/root/Game").music=false
		else:
			get_node("Time_whole").visible=false
			get_node("Killed").visible=false
			get_node("LevelDead").visible=false
			get_node("Portrait").visible=false
			if(help_choice==0):
				get_node("ArrowLeft").visible=true
				get_node("ArrowRight").visible=false
				get_node("Back").visible=false
			elif(help_choice==1):
				get_node("ArrowLeft").visible=false
				get_node("ArrowRight").visible=true
				get_node("Back").visible=false
			else:
				get_node("ArrowLeft").visible=false
				get_node("ArrowRight").visible=false
				get_node("Back").visible=true
			
			if(Input.is_action_just_pressed("move_left")):
				if(get_node("GameOver").visible==true):
					get_node("Click").play()
				help_choice=0
			if(Input.is_action_just_pressed("move_right")):
				if(get_node("GameOver").visible==true):
					get_node("Click").play()
				help_choice=1
			if(Input.is_action_just_pressed("down")):
				if(get_node("GameOver").visible==true):
					get_node("Click").play()
				help_choice=2
			if(Input.is_action_just_pressed("up") and help_choice==2):
				if(get_node("GameOver").visible==true):
					get_node("Click").play()
				help_choice=0
			if(Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("action") or Input.is_action_just_pressed("ui_accept")):
				if(help_choice==0):
					get_node("Controls2").visible=false
					get_node("Controls1").visible=true
				elif(help_choice==1):
					get_node("Controls1").visible=false
					get_node("Controls2").visible=true
				else:
					help=false
					get_node("Controls1").visible=false
					get_node("Controls2").visible=false
					get_node("HelpMenu").visible=false
					get_node("Back").visible=false
					setup()


func help_setup()->void:
	get_node("GameOver").visible=false
	get_node("ResetHover").visible=false
	get_node("Help").visible=false
	get_node("Quit").visible=false
	get_node("Time_whole").visible=false
	get_node("Killed").visible=false
	get_node("LevelDead").visible=false
	
	help_choice=0
	help=true
	
	get_node("HelpMenu").visible=true
	get_node("Controls1").visible=true


func setup()->void:
	get_node("Dim").visible=true
	choice=0
	get_node("GameOver").visible=true
	get_node("GameOver").frame=0
	yield(get_tree().create_timer(0.65), "timeout")
	dead_setup=true
	#yield(get_tree().create_timer(0.1), "timeout")
	get_node("Time_whole").visible=true
	get_node("Killed").visible=true
	get_node("LevelDead").visible=true
	get_node("ResetButton").visible=true
	get_node("HelpButton").visible=true
	get_node("QuitButton").visible=true
	get_node("Portrait").visible=true
	#yield(get_tree().create_timer(0.05), "timeout")
	#get_node("Time_whole").visible=true
	#get_node("Killed").visible=true
	#get_node("LevelDead").visible=true



func print_something(text: String)->void:
	if(last==text and get_node("DialogBox").visible==true):
		return
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


func _on_ResetButton_pressed() -> void:
	get_node("/root/Game").restart()
	get_node("/root/Game").can_pause=true


func _on_QuitButton_pressed() -> void:
	get_node("/root/Game").back_to_main_menu()


func _on_HelpButton_pressed() -> void:
	get_node("ResetButton").visible=false
	get_node("HelpButton").visible=false
	get_node("QuitButton").visible=false
	get_node("Time_whole").visible=false
	get_node("Killed").visible=false
	get_node("LevelDead").visible=false
	get_node("Portrait").visible=false
	
	get_node("Controls1").visible=true
	get_node("HelpMenu").visible=true
	get_node("LeftButton").visible=true
	get_node("RightButton").visible=true
	get_node("BackButton").visible=true


func _on_LeftButton_pressed() -> void:
	get_node("Controls1").visible=true
	get_node("Controls2").visible=false


func _on_RightButton_pressed() -> void:
	get_node("Controls1").visible=false
	get_node("Controls2").visible=true


func _on_BackButton_pressed() -> void:
	get_node("Controls1").visible=false
	get_node("Controls2").visible=false
	get_node("HelpMenu").visible=false
	get_node("LeftButton").visible=false
	get_node("RightButton").visible=false
	get_node("BackButton").visible=false
	setup()
