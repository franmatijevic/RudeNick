extends Node2D

var music:bool=true
var can_pause:=false

var player_health:int=4
var player_money:int=0
var player_rope:int=4
var player_bomb:int=4
var level:=0
var poisoned:=false
var shotgun:int=0
var goggles:=false

var shop_angry:int=0

var bomb_in_hands:bool=true

var red_key:=false
var white_key:=false
var green_key:=false

var old_health:int=0
var old_money:int=0
var old_rope:int=0
var old_bomb:int=0

var total_time:=0.0
var current_time:=0.0

var last_damage:String=" "

var temple:=false

var go_to_boss:=false

var boss_level:int=-1

func set_health()->void:
	if(get_node("World").has_node("Player")):
		get_node("World").get_node("Player").health=player_health
		get_node("World").get_node("Player").money=player_money
		get_node("World").get_node("Player").rope=player_rope
		get_node("World").get_node("Player").bomb=player_bomb
		get_node("World/Player").poisoned=poisoned
		get_node("World/Player").shotgun=shotgun

func _ready() -> void:
	shop_angry=0
	#get_node("PauseLayer/Pause").visible=false
	OS.window_fullscreen = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(delta: float) -> void:
	if(has_node("World")):
		if(Input.is_action_just_pressed("bomb") and get_node("World").has_node("Player")):
			if(get_node("World/Player").bomb>0):
				bomb_in_hands=!bomb_in_hands
			elif(get_node("World/Player").bomb==0):
				bomb_in_hands=false
	#if(has_node("World")):
	#	if(get_node("World").has_node("Player")):
	#		get_node("World/Player/Label").text=str(bomb_in_hands)


func restart()->void:
	restart_stats()
	var restart=preload("res://src/Levels/RestartScreen.tscn").instance()
	add_child(restart)
	get_node("/root/Game/World").queue_free()

func back_to_main_menu()->void:
	if(has_node("World")):
		get_node("World").queue_free()
	var main=preload("res://src/Levels/MainMenu.tscn").instance()
	add_child(main)
	restart_stats()

func restart_stats()->void:
	player_health=int(4)
	player_bomb=4
	player_money=0
	player_rope=4
	level=0
	poisoned=0
	shotgun=0
	shop_angry=0
	old_bomb=0
	old_health=0
	old_money=0
	old_rope=0
	total_time=0
	current_time=0
	last_damage=" "
	goggles=false
	temple=false
	red_key=false
	green_key=false
	white_key=false
	go_to_boss=false

func _get_viewport_center() -> Vector2:
	var transform : Transform2D = get_viewport_transform()
	var scale : Vector2 = transform.get_scale()
	return -transform.origin / scale + get_viewport_rect().size / scale / 2

func pause_menu(on: bool)->void:
	if(on):
		#get_node("World/Kanvas/UI").visible=false
		get_tree().paused = true
		#get_node("PauseNode/Pause/PauseMenu").visible=true
	else:
		#get_node("World/Kanvas/UI").visible=true
		#get_node("PauseNode/Pause/PauseMenu").visible=false
		get_tree().paused = false

func new_complete()->void:
	var comp = preload("res://src/Levels/LevelComplete.tscn").instance()
	if(get_node("World").temple):
		comp=preload("res://src/Levels/DungeonComplete.tscn").instance()
		print("Ovo je sad temple level")
	comp.position.x=0
	comp.position.y=0
	add_child(comp)
	comp.level=level
	if(has_node("World")):
		get_node("World").queue_free()
	if(has_node("MainMenu")):
		get_node("MainMenu").queue_free()

func new_level()->void:
	bomb_in_hands=true
	if(has_node("World")):
		get_node("World").queue_free()
	
	
	if(has_node("RestartScreen")):
		get_node("RestartScreen").queue_free()
	
	var world = preload("res://src/Levels/World.tscn").instance()
	if(level+1==boss_level):
		go_to_boss=true
	
	if(go_to_boss):
		world=preload("res://src/Levels/WorldBoss.tscn").instance()
		world.name="World"
	elif(temple):
		world = preload("res://src/Levels/WorldTemple.tscn").instance()
		world.name="World"
	
	
	
	world.global_position=global_position
	world.red=red_key
	world.green=green_key
	world.white=white_key
	
	world.temple=temple
	
	level=level+1
	world.level=level
	old_health=player_health
	old_bomb=player_bomb
	old_money=player_money
	old_rope=player_rope
	world.get_node("Kanvas/UI").get_node("LevelNumber").text=str(level)
	world.shop_angry=shop_angry
	
	world.level=level
	add_child(world)
	#get_tree().change_scene("res://src/Levels/World.tscn")
	if(has_node("DungeonComplete")):
		get_node("DungeonComplete").queue_free()
	
	if(has_node("LevelComplete")):
		get_node("LevelComplete").queue_free()
	if(has_node("MainMenu")):
		get_node("MainMenu").queue_free()
	set_health()

func game_over()->void:
	can_pause=false
	var time_in_seconds = 3
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_tree().reload_current_scene()

func credits()->void:
	get_node("Credits").visible=false
	get_node("Credits").queue_free()
	back_to_main_menu()
