extends Node2D


func _ready() -> void:
	name="MainMenu"
	title_animation()
	get_node("/root/Game").can_pause=false
	get_node("Music").play()
	if(!get_node("/root/Game").music):
		get_node("Music").volume_db=-80

func title_animation()->void:
	get_node("Credits").visible=true
	get_node("MusicOn").visible=true
	get_node("FlipMega").visible=false
	get_node("AnimatedSprite").animation="playing"
	get_node("AnimatedSprite").frame=0
	
	yield(get_tree().create_timer(0.4), "timeout")
	
	get_node("PlayButton").visible=true
	get_node("HelpButton").visible=true
	get_node("QuitButton").visible=true



func _process(delta: float) -> void:
	get_node("Background1").position.y-=delta*15
	if(get_node("Background1").position.y<0):
		get_node("Background1").position.y=192


func _on_PlayButton_pressed() -> void:
	get_node("AnimatedSprite").animation="default"
	get_node("Diff").visible=true
	get_node("Diff").frame=0
	
	get_node("Credits").visible=false
	get_node("MusicOn").visible=false
	
	get_node("PlayButton").visible=false
	get_node("HelpButton").visible=false
	get_node("QuitButton").visible=false
	
	yield(get_tree().create_timer(0.57), "timeout")
	
	get_node("NormalButton").visible=true
	get_node("EasyButton").visible=true
	get_node("BackButton").visible=true


func _on_HelpButton_pressed() -> void:
	get_node("Credits").visible=false
	get_node("MusicOn").visible=false
	get_node("AnimatedSprite").animation="default"
	get_node("PlayButton").visible=false
	get_node("HelpButton").visible=false
	get_node("QuitButton").visible=false
	
	get_node("HelpMenu").visible=true
	get_node("Controls1").visible=true
	get_node("LeftButton").visible=true
	get_node("RightButton").visible=true
	get_node("BackHelpButton").visible=true
	get_node("FlipMega").visible=true

func _on_QuitButton_pressed() -> void:
	get_tree().quit()


func _on_NormalButton_pressed() -> void:
	get_node("/root/Game").easy_mode=false
	get_node("/root/Game").can_pause=true
	get_parent().level=0
	get_parent().new_level_from_menu(false)


func _on_EasyButton_pressed() -> void:
	get_node("/root/Game").easy_mode=true
	get_node("/root/Game").can_pause=true
	get_parent().level=0
	get_parent().new_level_from_menu(true)

func _on_BackButton_pressed() -> void:
	title_animation()
	get_node("Diff").visible=false
	get_node("NormalButton").visible=false
	get_node("EasyButton").visible=false
	get_node("BackButton").visible=false
	get_node("FlipMega").visible=false


func _on_LeftButton_pressed() -> void:
	get_node("Controls1").visible=true
	get_node("Controls2").visible=false


func _on_RightButton_pressed() -> void:
	get_node("Controls1").visible=false
	get_node("Controls2").visible=true


func _on_BackHelpButton_pressed() -> void:
	get_node("HelpMenu").visible=false
	get_node("Controls1").visible=false
	get_node("Controls2").visible=false
	get_node("LeftButton").visible=false
	get_node("RightButton").visible=false
	get_node("BackHelpButton").visible=false
	title_animation()


func _on_Credits_pressed() -> void:
	var credits=preload("res://src/Levels/Credits.tscn").instance()
	get_node("/root/Game").add_child(credits)
	get_node("/root/Game/MainMenu").visible=false
	queue_free()


func _on_MusicOn_pressed() -> void:
	if(get_node("/root/Game").music):
		get_node("/root/Game").music=false
		get_node("Music").volume_db=-80
		get_node("MusicOn").set_texture_pressed(load("res://Assets/MusicOnOff/music_button_muted_hover.png"))
		get_node("MusicOn").set_texture(load("res://Assets/MusicOnOff/music_button_muted.png"))
	else:
		get_node("/root/Game").music=true
		get_node("Music").volume_db=-15
		get_node("MusicOn").set_texture_pressed(load("res://Assets/MusicOnOff/music_button_hover.png"))
		get_node("MusicOn").set_texture(load("res://Assets/MusicOnOff/music_button.png"))


func _on_FlipMega_pressed() -> void:
	get_node("/root/Game").control_flip=!get_node("/root/Game").control_flip
