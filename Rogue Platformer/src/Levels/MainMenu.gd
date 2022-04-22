extends Node2D

var choice:int=0
#play 0
#help 1
#quit 2


func title_animation()->void:
	var time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("AnimatedSprite").animation="playing"
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
	
	if(Input.is_action_just_pressed("down")):
		choice+=1
		if(choice==3):
			choice=0
	if(Input.is_action_just_pressed("up")):
		choice-=1
		if(choice==-1):
			choice=2
	if(Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("ui_accept")):
		if(choice==0):
			get_node("/root/Game").can_pause=true
			get_parent().level=0
			get_parent().new_level()
		elif(choice==1):
			pass
		else:
			get_tree().quit()
	
	
	
	get_node("Background1").position.y-=delta*15
	if(get_node("Background1").position.y<0):
		get_node("Background1").position.y=192

var help_page:=false

