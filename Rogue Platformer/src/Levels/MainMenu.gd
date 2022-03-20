extends Node2D

func title_animation()->void:
	var time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("AnimatedSprite").animation="playing"
	time_in_seconds=0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("RudeNick").visible=true
	get_node("PlayButton").visible=true
	get_node("HelpButton").visible=true
	get_node("QuitButton").visible=true
	get_node("GameMusic").play()
	get_node("AnimatedSprite").animation="default"


func _ready() -> void:
	title_animation()
	get_node("Help/Controls").animation="an1"

func _process(delta: float) -> void:
	if(get_node("Help/BackHover2/BackHover").visible):
		if(Input.is_action_just_pressed("mouse_left")):
			help_page=false
			title_animation()
			get_node("Help").visible=false
			get_node("Help/Controls").animation="an1"
			get_node("AnimatedSprite").animation="playing"
	if(get_node("Help").visible):
		if(Input.is_action_just_pressed("mouse_left")):
			if(get_node("Help/GoRight/ArrowRight").visible):
				get_node("Help/Controls").animation="an2"
				help_page=true
			if(get_node("Help/GoLeft/ArrowLeft").visible):
				get_node("Help/Controls").animation="an1"
				help_page=false

var help_page:=false

func call_help()->void:
	get_node("RudeNick").visible=false
	get_node("PlayButton").visible=false
	get_node("HelpButton").visible=false
	get_node("QuitButton").visible=false
	get_node("Help").visible=true

func _on_Button_pressed() -> void:
	get_parent().level=0
	get_parent().new_level()

#Back Button Help
func _on_Area2D_mouse_entered() -> void:
	get_node("Help/BackHover2/BackHover").visible=true
func _on_BackButtonHelp_mouse_exited() -> void:
	get_node("Help/BackHover2/BackHover").visible=false

#Go right on help menu
func _on_Right_mouse_entered() -> void:
	if(!help_page):
		get_node("Help/GoRight/ArrowRight").visible=true

func _on_Right_mouse_exited() -> void:
	get_node("Help/GoRight/ArrowRight").visible=false

#Go left on help menu
func _on_Left_mouse_entered() -> void:
	if(help_page):
		get_node("Help/GoLeft/ArrowLeft").visible=true
func _on_Left_mouse_exited() -> void:
	get_node("Help/GoLeft/ArrowLeft").visible=false
