extends CanvasLayer

var choose=2
#music = 3
#back = 2
#help = 1
#quit = 0

var help_menu:=false
var help_page:=false
var help_choose=2
#left = 2
#right = 1
#back = 0

var music:=true

func _ready():
	set_visible(false)
	get_node("Help/Controls").animation="an1"

func _input(event):
	if(event.is_action_pressed("pause") and get_node("/root/Game").can_pause):
		music=get_node("/root/Game").music
		if(music):
			get_node("Buttons/MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
		else:
			get_node("Buttons/MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
		
		choose=2
		var value:int=0
		if(get_tree().paused):
			value=-15
		else:
			value=-30
		if(!music):
			value=-80
		if(music==true):
			if(get_node("/root/Game").has_node("World")):
				if(get_node("/root/Game/World").has_node("Music1") and get_node("/root/Game/World/Music1").is_playing()):
					get_node("/root/Game/World/Music1").set_volume_db(value)
				elif(get_node("/root/Game/World").has_node("Music2") and get_node("/root/Game/World/Music2").is_playing()):
					get_node("/root/Game/World/Music2").set_volume_db(value)
				elif(get_node("/root/Game/World").has_node("Music3") and get_node("/root/Game/World/Music3").is_playing()):
					get_node("/root/Game/World/Music3").set_volume_db(value)
				elif(get_node("/root/Game/World").has_node("Rage") and get_node("/root/Game/World/Rage").is_playing()):
					get_node("/root/Game/World/Rage").set_volume_db(value)
		set_buttons()
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused
		if(get_tree().paused):
			if(!music):
				get_node("/root/Game/World/Music1").volume_db=-80
				get_node("/root/Game/World/Music2").volume_db=-80
				get_node("/root/Game/World/Music3").volume_db=-80
			get_node("AnimatedSprite").frame=0
			choose=2
		else:
			help_menu=false
	if(event.is_action_pressed("up")):
		if(get_tree().paused==true):
			get_node("Click").play()
		if(!help_menu):
			if(choose==3):
				choose=0
			else:
				choose=choose+1
			set_buttons()
		else:
			if(help_choose==0):
				help_choose=2
			set_help()
	if(event.is_action_pressed("down")):
		if(get_tree().paused==true):
			get_node("Click").play()
		if(!help_menu):
			if(choose==0):
				choose=3
			else:
				choose=choose-1
			set_buttons()
		else:
			help_choose=0
			set_help()
	
	if(event.is_action_pressed("move_right") and help_menu):
		if(get_tree().paused==true):
			get_node("Click").play()
		if(help_choose!=0):
			help_choose=help_choose-1
			if(help_choose==-1):
				help_choose=2
			set_help()
	if(event.is_action_pressed("move_left") and help_menu):
		if(get_tree().paused==true):
			get_node("Click").play()
		if(help_choose!=2):
			help_choose=help_choose+1
			if(help_choose==3):
				help_choose=2
			set_help()
	
	if(event.is_action_pressed("action") or event.is_action_pressed("ui_accept") or event.is_action_pressed("buy")):
		music=get_node("/root/Game").music
		if(get_tree().paused and !help_menu):
			if(choose==0):
				set_visible(false)
				get_tree().paused = false
				get_node("/root/Game").back_to_main_menu()
				#get_tree().reload_current_scene()
			elif(choose==2):
				get_tree().paused = false
				set_visible(false)
				music=get_node("/root/Game").music
				if(!music):
					if(get_node("/root/Game/World").has_node("Music1") and get_node("/root/Game/World/Music1").is_playing()):
						get_node("/root/Game/World/Music1").set_volume_db(-15)
					elif(get_node("/root/Game/World").has_node("Music2") and get_node("/root/Game/World/Music2").is_playing()):
						get_node("/root/Game/World/Music2").set_volume_db(-15)
					elif(get_node("/root/Game/World").has_node("Music3") and get_node("/root/Game/World/Music3").is_playing()):
						get_node("/root/Game/World/Music3").set_volume_db(-15)
					elif(get_node("/root/Game/World").has_node("Rage") and get_node("/root/Game/World/Rage").is_playing()):
						get_node("/root/Game/World/Rage").set_volume_db(-15)
			elif(choose==1):
				help_menu=true
				help_choose=2
				get_node("AnimatedSprite").visible=false
				get_node("Buttons").visible=false
				get_node("Help").visible=true
				set_help()
			else:
				if(get_node("/root/Game").music):
					get_node("/root/Game").music=false
					if(get_node("/root/Game/World").has_node("Music1") and get_node("/root/Game/World/Music1").is_playing()):
						get_node("/root/Game/World/Music1").set_volume_db(-80)
					elif(get_node("/root/Game/World").has_node("Music2") and get_node("/root/Game/World/Music2").is_playing()):
						get_node("/root/Game/World/Music2").set_volume_db(-80)
					elif(get_node("/root/Game/World").has_node("Music3") and get_node("/root/Game/World/Music3").is_playing()):
						get_node("/root/Game/World/Music3").set_volume_db(-80)
					elif(get_node("/root/Game/World").has_node("Rage") and get_node("/root/Game/World/Rage").is_playing()):
						get_node("/root/Game/World/Rage").set_volume_db(-80)
				else:
					get_node("/root/Game").music=true
					if(get_node("/root/Game/World").has_node("Music1") and get_node("/root/Game/World/Music1").is_playing()):
						get_node("/root/Game/World/Music1").set_volume_db(-30)
					elif(get_node("/root/Game/World").has_node("Music2") and get_node("/root/Game/World/Music2").is_playing()):
						get_node("/root/Game/World/Music2").set_volume_db(-30)
					elif(get_node("/root/Game/World").has_node("Music3") and get_node("/root/Game/World/Music3").is_playing()):
						get_node("/root/Game/World/Music3").set_volume_db(-30)
					elif(get_node("/root/Game/World").has_node("Rage") and get_node("/root/Game/World/Rage").is_playing()):
						get_node("/root/Game/World/Rage").set_volume_db(-30)
				music=get_node("/root/Game").music
				set_buttons()
				
		if(help_menu):
			if(help_choose==2):
				if(help_page):
					get_node("Help/Controls").animation="an1"
					help_page=false
			elif(help_choose==1):
				if(!help_page):
					get_node("Help/Controls").animation="an2"
					help_page=true
			else:
				help_menu=false
				get_node("AnimatedSprite").visible=true
				get_node("Buttons").visible=true
				get_node("Help").visible=false

func set_help()->void:
	if(help_choose==0):
		get_node("Help/GoBack").visible=true
		get_node("Help/GoLeft").visible=false
		get_node("Help/GoRight").visible=false
	elif(help_choose==1):
		get_node("Help/GoBack").visible=false
		get_node("Help/GoLeft").visible=false
		get_node("Help/GoRight").visible=true
	else:
		get_node("Help/GoBack").visible=false
		get_node("Help/GoLeft").visible=true
		get_node("Help/GoRight").visible=false

func set_buttons()->void:
	if(music):
		get_node("Buttons/MusicButton").texture=load("res://Assets/MusicOnOff/music_button.png")
	else:
		get_node("Buttons/MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted.png")
	
	if(choose==0):
		get_node("Buttons/Back").visible=false
		get_node("Buttons/Help").visible=false
		get_node("Buttons/Quit").visible=true
	elif(choose==1):
		get_node("Buttons/Back").visible=false
		get_node("Buttons/Help").visible=true
		get_node("Buttons/Quit").visible=false
	elif(choose==2):
		get_node("Buttons/Back").visible=true
		get_node("Buttons/Help").visible=false
		get_node("Buttons/Quit").visible=false
	else:
		get_node("Buttons/Back").visible=false
		get_node("Buttons/Help").visible=false
		get_node("Buttons/Quit").visible=false
		if(music):
			get_node("Buttons/MusicButton").texture=load("res://Assets/MusicOnOff/music_button_hover.png")
		else:
			get_node("Buttons/MusicButton").texture=load("res://Assets/MusicOnOff/music_button_muted_hover.png")

func set_visible(is_visible):
	if(get_node("/root").has_node("Intro")):
		return
	for node in get_children():
		if((node.name!="Buttons" and is_visible) or !is_visible):
			if(node.name!="Click"):
				node.visible = is_visible
	get_node("Help").visible=false
	var time_in_seconds = 0.2
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("Buttons").visible=is_visible
	
	if(music!=null and music==true and !is_visible):
		if(!get_node("/root/Game").has_node("World")):
			return
		if(get_node("/root/Game/World").has_node("Music1") and get_node("/root/Game/World/Music1").is_playing()):
			get_node("/root/Game/World/Music1").set_volume_db(-15)
		elif(get_node("/root/Game/World").has_node("Music2") and get_node("/root/Game/World/Music2").is_playing()):
			get_node("/root/Game/World/Music2").set_volume_db(-15)
		elif(get_node("/root/Game/World").has_node("Music3") and get_node("/root/Game/World/Music3").is_playing()):
			get_node("/root/Game/World/Music3").set_volume_db(-15)
		elif(get_node("/root/Game/World").has_node("Rage") and get_node("/root/Game/World/Rage").is_playing()):
			get_node("/root/Game/World/Rage").set_volume_db(-15)
