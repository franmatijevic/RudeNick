extends Node2D

var health
var level

var playerx
var playery

var polje = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
var start
var x
var y
var array = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
#Start = 4
#Start with dropdown = 5
#Hallway = 1
#Dropdown = 2
#Critical path > 0
#End of level = 9
#Side tile = 0

func _init()->void:
	var transition=preload("res://src/Other/TransitionEffect.tscn").instance()
	transition.choice=true
	#add_child(transition)
	
	randomize()
	start=randi()%4
	polje[0][start]=4
	x=start
	y=0
	var banned_route
	
	while(y<4):
		randomize()
		var direction = randi()%3
		if(banned_route==0 and direction==0):
			direction=1
		if(banned_route==1 and direction==1):
			direction=0
		
		if(direction == 0):
			if(x==0 or banned_route==0):
				direction = 1
			else: 
				x=x-1
				banned_route=1
		
		if(direction == 1):
			if(x==3 or banned_route == 1):
				direction=2
			else: 
				x=x+1
				banned_route=0
		
		if(direction == 2):
			if(y==3):
				polje[y][x]=9
				#print("exit")
				break
			y=y+1
			if(polje[y-1][x]==4): 
				polje[y-1][x]=5
			else: polje[y-1][x]=2
			banned_route=4
		
		#if(direction==0): print("go left")
		#if(direction==1): print("go right")
		#if(direction==2): print("go down")
		polje[y][x]=1
	
	for i in range(3):
		for j in range(4):
			if(polje[i+1][j]==1):
				if(polje[i][j]==2 or polje[i][j]==5):
					polje[i+1][j]=6
	
	
	for i in range(4):
		for j in range(4):
			match polje[i][j]:
				1:
					create_hallway(i,j)
				2:
					create_dropdown(i,j)
				4:
					array[i][j]=preload("res://src/levelPieces/start1.tscn").instance()
					array[i][j].global_position.x=80 + j * 160
					array[i][j].global_position.y=64 + i * 128
					add_child(array[i][j])
				5:
					create_startdropdown(i,j)
				6: 
					create_hallwaywithdrop(i,j)
				9:
					array[i][j]=preload("res://src/levelPieces/exit1.tscn").instance()
					array[i][j].global_position.x=80 + j * 160
					array[i][j].global_position.y=64 + i * 128
					add_child(array[i][j])
				0:
					create_side_room(i,j)

func _process(delta: float) -> void:
	pass
	if(Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()
	
	if(Input.is_action_just_pressed("jump") and !has_node("Player")):
		get_tree().reload_current_scene()
		pass

func _ready() -> void:
	pass
	get_node("BlackScreen").queue_free()
	add_player()

func create_hallwaywithdrop(i:int, j:int)->void:
	randomize()
	var room=randi()%4
	match room:
		0:
			array[i][j]=preload("res://src/levelPieces/hallwaydrop1.tscn").instance()
		1:
			array[i][j]=preload("res://src/levelPieces/hallwaydrop2.tscn").instance()
		2:
			array[i][j]=preload("res://src/levelPieces/hallway5.tscn").instance()
		3: 
			array[i][j]=preload("res://src/levelPieces/hallwaywithdrop4.tscn").instance()
	array[i][j].global_position.x=80 + j * 160
	array[i][j].global_position.y=64 + i * 128
	add_child(array[i][j])


func create_startdropdown(i:int, j:int)->void:
	randomize()
	var room=randi()%2
	match room:
		0:
				array[i][j]=preload("res://src/levelPieces/startdropdown1.tscn").instance()
		1:
				array[i][j]=preload("res://src/levelPieces/startdropdown2.tscn").instance()
	array[i][j].global_position.x=80 + j * 160
	array[i][j].global_position.y=64 + i * 128
	add_child(array[i][j])

func create_dropdown(i:int, j:int)->void:
	randomize()
	var room=randi()%3
	match room:
		0:
			array[i][j]=preload("res://src/levelPieces/dropdown1.tscn").instance()
		1:
			array[i][j]=preload("res://src/levelPieces/dropdown2.tscn").instance()
		2:
			array[i][j]=preload("res://src/levelPieces/dropdown3.tscn").instance()
	array[i][j].global_position.x=80 + j * 160
	array[i][j].global_position.y=64 + i * 128
	add_child(array[i][j])

func create_hallway(i:int, j:int) ->void:
	randomize()
	var room=randi()%10
	match room:
		0:
			array[i][j]=preload("res://src/levelPieces/hallway1.tscn").instance()
		1:
			array[i][j]=preload("res://src/levelPieces/hallblanka1.tscn").instance()
		2:
			array[i][j]=preload("res://src/levelPieces/hallblanka2.tscn").instance()
		3:
			array[i][j]=preload("res://src/levelPieces/hallblanka3.tscn").instance()
		4:
			array[i][j]=preload("res://src/levelPieces/dropdown2.tscn").instance()
		5:
			array[i][j]=preload("res://src/levelPieces/hallway3.tscn").instance()
		6:
			array[i][j]=preload("res://src/levelPieces/hallway5.tscn").instance()
		7:
			array[i][j]=preload("res://src/levelPieces/dropdown3.tscn").instance()
		8:
			array[i][j]=preload("res://src/levelPieces/hallway4.tscn").instance()
		9:
			array[i][j]=preload("res://src/levelPieces/hallwaydrop3.tscn").instance()
	array[i][j].global_position.x=80 + j * 160
	array[i][j].global_position.y=64 + i * 128
	add_child(array[i][j])

func create_side_room(i:int, j:int) ->void:
	randomize()
	var room=randi()%7
	match room:
		0:
			array[i][j]=preload("res://src/levelPieces/sideroom1.tscn").instance()
		1:
			array[i][j]=preload("res://src/levelPieces/lootbank.tscn").instance()
		2:
			array[i][j]=preload("res://src/levelPieces/blanka1.tscn").instance()
		3:
			array[i][j]=preload("res://src/levelPieces/blanka2.tscn").instance()
		4:
			array[i][j]=preload("res://src/levelPieces/sideroom2.tscn").instance()
		5:
			array[i][j]=preload("res://src/levelPieces/sideroom3.tscn").instance()
		6:
			array[i][j]=preload("res://src/levelPieces/sideroom4.tscn").instance()
	array[i][j].global_position.x=80 + j * 160
	array[i][j].global_position.y=64 + i * 128
	add_child(array[i][j])

func add_player()->void:
	var player = preload("res://src/Actors/Player.tscn").instance()
	player.global_position.x=80+start*160
	player.global_position.y=34
	add_child(player)

