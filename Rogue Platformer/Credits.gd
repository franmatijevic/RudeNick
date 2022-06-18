extends Node2D

var click:=true

var time:float=0.2

var volume_down:=false

var in_game:=false
var total_time:float=0.0
var total_levels:int=0
var total_score:int=0

var add:int=0

func _ready() -> void:
	if(get_node("/root/Game").easy_mode):
		get_node("Thank2").text="Good job, now try on normal mode!"
	#else:
	#	get_node("Thank2").text="Congrats!"
	get_node("Music").play()
	if(in_game):
		add=14
		get_node("Text/Time").visible=true
		get_node("Text/Level").visible=true
		get_node("Text/Score").visible=true
		get_node("Text/Thank2").visible=true
		var minutes=floor(total_time/60.0)
		var seconds=int(total_time)%60
		if(seconds>9):
			get_node("Text/Time").text+=str(minutes)+":"+str(seconds)
		else:
			get_node("Text/Time").text+=str(minutes)+":0"+str(seconds)
		get_node("Text/Score").text+="$"
		get_node("Text/Score").text+=str(total_score*100)
		get_node("Text/Level").text+=str(total_levels)

func _process(delta: float) -> void:
	if(volume_down):
		get_node("Music").volume_db-=15*delta
	
	time+=delta
	if(time>58+add):
		volume_down=true
	if(time>60+add):
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
