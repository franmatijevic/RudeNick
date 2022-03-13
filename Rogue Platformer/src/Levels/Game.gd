extends Node2D

var player_health:int=4
var player_money:int=0
var player_rope:int=4
var player_bomb:int=4
var level:=0

var old_health:int=0
var old_money:int=0
var old_rope:int=0
var old_bomb:int=0

var total_time:=0.0
var current_time:=0.0

var last_damage:String=" "

var paused:=preload("res://src/Other/PauseScreen.tscn").instance()

func set_health()->void:
	get_node("World").get_node("Player").health=player_health
	get_node("World").get_node("Player").money=player_money
	get_node("World").get_node("Player").rope=player_rope
	get_node("World").get_node("Player").bomb=player_bomb

func _ready() -> void:
	OS.window_fullscreen = true

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("ui_cancel") and has_node("World")):
		if(get_tree().paused == false):
			get_tree().paused = true
			pause_menu(true)
		else:
			pause_menu(false)
			get_tree().paused = false

func _get_viewport_center() -> Vector2:
	var transform : Transform2D = get_viewport_transform()
	var scale : Vector2 = transform.get_scale()
	return -transform.origin / scale + get_viewport_rect().size / scale / 2

func pause_menu(on: bool)->void:
	if(on):
		get_node("World/Kanvas/UI").visible=false
		get_node("PauseScreen").visible=true
		#get_node("World").visible=false
		#var time_in_seconds = 0.5
		#yield(get_tree().create_timer(time_in_seconds), "timeout")
	else:
		get_node("World/Kanvas/UI").visible=true
		get_node("PauseScreen").visible=false
		#get_node("World").visible=true

func new_complete()->void:
	var comp = preload("res://src/Levels/LevelComplete.tscn").instance()
	comp.position.x=0
	comp.position.y=0
	add_child(comp)
	comp.level=level
	if(has_node("World")):
		get_node("World").queue_free()
	if(has_node("MainMenu")):
		get_node("MainMenu").queue_free()

func new_level()->void:
	var world = preload("res://src/Levels/World.tscn").instance()
	world.global_position=global_position
	level=level+1
	old_health=player_health
	old_bomb=player_bomb
	old_money=player_money
	old_rope=player_rope
	world.get_node("Kanvas/UI").get_node("LevelNumber").text=str(level)
	add_child(world)
	if(has_node("LevelComplete")):
		get_node("LevelComplete").queue_free()
	if(has_node("MainMenu")):
		get_node("MainMenu").queue_free()
	set_health()

