extends Node2D

var choice:int=0
#play 0
#help 1
#quit 2
#credits 3
#music on off 4
var enable:=false

var help:=false
var help_choice:int=0
#left 0
#right 1
#back 2
var music:=false

var diff=false
var diff_choice:int=0
#easy 0
#normal 1
#back 2

func title_animation()->void:
	get_node("RudeNick").visible=false
	choice=0
	var time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("AnimatedSprite").animation="playing"
	get_node("AnimatedSprite").frame=0
	enable=true
	time_in_seconds=0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("RudeNick").visible=true
	#get_node("PlayButton").visible=true
	#get_node("HelpButton").visible=true
	#get_node("QuitButton").visible=true
	#get_node("PlaySprite").visible=true
	#get_node("HelpSprite").visible=true
	#get_node("QuitSprite").visible=true
	
	get_node("AnimatedSprite").animation="default"
	
	get_node("PlayButton").visible=true
	get_node("HelpButton").visible=true
	get_node("QuitButton").visible=true
	
	if(music==false):
		music=true
		get_node("Music").play()


func _ready() -> void:
	get_node("/root/Game").can_pause=false
	title_animation()
	#get_node("Help/Controls").animation="an1"
	if(!get_node("/root/Game").music):
		get_node("Music").volume_db=-80

func _process(delta: float) -> void:
	
	if(enable and !help and !diff):
		if(choice==0):
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1_hover.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1.png")
			get_node("credits").texture=load("res://Assets/MainMenuStuff/credits.png")
			if(get_node("/root/Game").music):
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
			else:
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
		elif(choice==1):
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1_hover.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1.png")
			get_node("credits").texture=load("res://Assets/MainMenuStuff/credits.png")
			if(get_node("/root/Game").music):
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
			else:
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
		elif(choice==2):
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1_hover.png")
			get_node("credits").texture=load("res://Assets/MainMenuStuff/credits.png")
			if(get_node("/root/Game").music):
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
			else:
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
		elif(choice==3):
			if(get_node("/root/Game").music):
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
			else:
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1.png")
			get_node("credits").texture=load("res://Assets/MainMenuStuff/credits_hover.png")
		else:
			get_node("PlaySprite").texture=load("res://Assets/MainMenuStuff/play_button_1.png")
			get_node("HelpSprite").texture=load("res://Assets/MainMenuStuff/help_button_1.png")
			get_node("QuitSprite").texture=load("res://Assets/MainMenuStuff/quit_button_1.png")
			get_node("credits").texture=load("res://Assets/MainMenuStuff/credits.png")
			if(get_node("/root/Game").music):
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_hover.png")
			else:
				get_node("MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted_hover.png")
	elif(help and !diff):
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
			get_node("Click").play()
			help_choice=2
		if(Input.is_action_just_pressed("move_left")):
			get_node("Click").play()
			help_choice=0
		if(Input.is_action_just_pressed("move_right")):
			get_node("Click").play()
			help_choice=1
		if(Input.is_action_just_pressed("up") and help_choice==2):
			get_node("Click").play()
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
	elif(diff and !help):
		if(Input.is_action_just_pressed("down")):
			diff_choice+=1
			if(diff_choice==3):
				diff_choice=0
		if(Input.is_action_just_pressed("up")):
			diff_choice-=1
			if(diff_choice==-1):
				diff_choice=2
		if(diff_choice==0 and get_node("Diff").frame==8):
			get_node("EasyButtonHover").visible=false
			get_node("NormalButtonHover").visible=true
			get_node("BackDiff").visible=false
			get_node("Chad").visible=true
			get_node("Baby").visible=false
			get_node("Desc/Desc").text="*This mode is the prefered way of playing."
		elif(diff_choice==1 and get_node("Diff").frame==8):
			get_node("EasyButtonHover").visible=true
			get_node("NormalButtonHover").visible=false
			get_node("BackDiff").visible=false
			get_node("Chad").visible=false
			get_node("Baby").visible=true
			get_node("Desc/Desc").text="*In this mode, you start with more resurses and enemies do less damage."
		elif(get_node("Diff").frame==8):
			get_node("EasyButtonHover").visible=false
			get_node("NormalButtonHover").visible=false
			get_node("BackDiff").visible=true
			get_node("Chad").visible=false
			get_node("Baby").visible=false
			get_node("Desc/Desc").text=" "
			#title_animation()
	if((Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("ui_accept")) and enable and !help and diff):
		if(diff_choice==0):
			get_node("/root/Game").easy_mode=false
			get_node("/root/Game").can_pause=true
			get_parent().level=0
			get_parent().new_level()
		elif(diff_choice==1):
			get_node("/root/Game").easy_mode_setup()
			get_node("/root/Game").easy_mode=true
			get_node("/root/Game").can_pause=true
			get_parent().level=0
			get_parent().new_level()
		else:
			enable=false
			get_node("credits").visible=true
			get_node("MusicButton").visible=true
			title_animation()
			get_node("Diff").visible=false
			get_node("EasyButtonHover").visible=false
			get_node("NormalButtonHover").visible=false
			get_node("BackDiff").visible=false
			get_node("Desc/Desc").visible=false
			diff=false
	
	if(Input.is_action_just_pressed("down")):
		get_node("Click").play()
		choice+=1
		if(choice==5):
			choice=0
	if(Input.is_action_just_pressed("up")):
		get_node("Click").play()
		choice-=1
		if(choice==-1):
			choice=4
	if(Input.is_action_just_pressed("move_left") and choice==4):
		get_node("Click").play()
		choice=3
	
	if(Input.is_action_just_pressed("move_right") and choice==3):
		get_node("Click").play()
		choice=4
	
	if((Input.is_action_just_pressed("buy") or Input.is_action_just_pressed("ui_accept")) and enable and !help and !diff):
		get_node("Click").play()
		if(choice==0):
			setup_diff()
			#get_node("/root/Game").can_pause=true
			#get_parent().level=0
			#get_parent().new_level()
		elif(choice==1):
			setup_help()
		elif(choice==2):
			get_tree().quit()
		elif(choice==3):
			var credits=preload("res://src/Levels/Credits.tscn").instance()
			get_node("/root/Game").add_child(credits)
			get_node("/root/Game/MainMenu").visible=false
			get_node("/root/Game/MainMenu").queue_free()
		else:
			if(get_node("/root/Game").music):
				get_node("/root/Game").music=false
				get_node("Music").volume_db=-80
			else:
				get_node("/root/Game").music=true
				get_node("Music").volume_db=-15
	
	
	
	get_node("Background1").position.y-=delta*15
	if(get_node("Background1").position.y<0):
		get_node("Background1").position.y=192

func setup_diff()->void:
	diff=true
	diff_choice=0
	get_node("PlaySprite").visible=false
	get_node("RudeNick").visible=false
	get_node("HelpSprite").visible=false
	get_node("QuitSprite").visible=false
	get_node("Diff").frame=0
	get_node("Diff").visible=true
	get_node("credits").visible=false
	get_node("MusicButton").visible=false
	get_node("Desc/Desc").visible=true

func setup_help()->void:
	help=true
	help_choice=0
	get_node("PlaySprite").visible=false
	get_node("RudeNick").visible=false
	get_node("HelpSprite").visible=false
	get_node("QuitSprite").visible=false
	
	get_node("HelpMenu").visible=true
	get_node("Controls1").visible=true


func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_PlayButton_pressed() -> void:
	setup_diff()
	get_node("AnimatedSprite").visible=false
	yield(get_tree().create_timer(0.56), "timeout")
	
	get_node("PlayButton").visible=false
	get_node("HelpButton").visible=false
	get_node("QuitButton").visible=false
	get_node("RudeNick").visible=false
	
	get_node("NormalButton").visible=true
	get_node("EasyButton").visible=true
	get_node("BackButton").visible=true
	get_node("Chad").visible=true
	get_node("Baby").visible=true


func _on_HelpButton_pressed() -> void:
	setup_help()
	get_node("LeftButton").visible=true
	get_node("RightButton").visible=true
	get_node("BackHelpButton").visible=true
	
	get_node("PlayButton").visible=false
	get_node("HelpButton").visible=false
	get_node("QuitButton").visible=false


func _on_LeftButton_pressed() -> void:
	get_node("Controls1").visible=true
	get_node("Controls2").visible=false


func _on_RightButton_pressed() -> void:
	get_node("Controls1").visible=false
	get_node("Controls2").visible=true

func _on_BackHelpButton_pressed() -> void:
	title_animation()
	get_node("LeftButton").visible=false
	get_node("RightButton").visible=false
	get_node("BackHelpButton").visible=false
	get_node("Controls1").visible=false
	get_node("Controls2").visible=false
	get_node("HelpMenu").visible=false
	
	get_node("ArrowLeft").visible=false


func _on_BackButton_pressed() -> void:
	title_animation()
	get_node("LeftButton").visible=false
	get_node("RightButton").visible=false
	get_node("BackHelpButton").visible=false
	get_node("Controls1").visible=false
	get_node("Controls2").visible=false
	get_node("HelpMenu").visible=false
	get_node("ArrowLeft").visible=false
	
	get_node("NormalButton").visible=false
	get_node("EasyButton").visible=false
	get_node("BackButton").visible=false
	get_node("Diff").visible=false
	
	get_node("Chad").visible=false
	get_node("Baby").visible=false
