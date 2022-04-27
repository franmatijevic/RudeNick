extends Node2D

var choice:int=0
#play 0
#help 1
#quit 2
var enable:=false

var help:=false
var help_choice:int=0
#left 0
#right 1
#back 2

func title_animation()->void:
	get_node("RudeNick").visible=false
	choice=0
	var time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("AnimatedSprite").animation="playing"
	enable=true
	time_in_seconds=0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("RudeNick").visible=true
	#get_node("PlayButton").visible=true
	#get_node("HelpButton").visible=true
	#get_node("QuitButton").visible=true
	get_node("PlaySprite").visible=true
	get_node("HelpSprite").visible=true
	get_node("QuitSprite").visible=true
	
	get_node("GameMusic").play()
	get_node("AnimatedSprite").animation="default"


func _ready() -> void:
	title_animation()
	#get_node("Help/Controls").animation="an1"

func _process(delta: float) -> void:
	if(enable and !help):
		if(choice==0):
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1_hover.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1.png")
		elif(choice==1):
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1_hover.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1.png")
		else:
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1_hover.png")
	elif(help):
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
		if(Input.is_action_just_pressed("down")):
			help_choice=2
		if(Input.is_action_just_pressed("move_left")):
			help_choice=0
		if(Input.is_action_just_pressed("move_right")):
			help_choice=1
		if(Input.is_action_just_pressed("up") and help_choice==2):
			help_choice=0
		if(Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("ui_accept")):
			if(help_choice==0):
				get_node("Controls1").visible=true
				get_node("Controls2").visible=false
			elif(help_choice==1):
				get_node("Controls1").visible=false
				get_node("Controls2").visible=true
			else:
				enable=false
				help=false
				get_node("Controls1").visible=false
				get_node("Controls2").visible=false
				get_node("HelpMenu").visible=false
				get_node("Back").visible=false
				title_animation()
	
	if(Input.is_action_just_pressed("down")):
		choice+=1
		if(choice==3):
			choice=0
	if(Input.is_action_just_pressed("up")):
		choice-=1
		if(choice==-1):
			choice=2
	if((Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("ui_accept")) and enable and !help):
		if(choice==0):
			get_node("/root/Game").can_pause=true
			get_parent().level=0
			get_parent().new_level()
		elif(choice==1):
			setup_help()
		else:
			get_tree().quit()
	
	
	
	get_node("Background1").position.y-=delta*15
	if(get_node("Background1").position.y<0):
		get_node("Background1").position.y=192

func setup_help()->void:
	help=true
	help_choice=0
	get_node("PlaySprite").visible=false
	get_node("PlaySprite").visible=false
	get_node("HelpSprite").visible=false
	get_node("QuitSprite").visible=false
	
	get_node("HelpMenu").visible=true
	get_node("Controls1").visible=true
