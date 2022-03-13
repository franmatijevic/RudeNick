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
#shop = 7

var current_time:=0.0

var dungeon:=false

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
	
	var shop=randi()%10
	
	var all_shops_i=[0,0,0,0,0,0,0,0]
	var all_shops_j=[0,0,0,0,0,0,0,0]
	var dir_shops=[false,false,false,false,false,false,false,false]
	var n_of_shops:int=0
	var where_shop
	
	if(shop==0):
		for i in range(4):
			for j in range(4):
				if(polje[i][j]==0):
					if(j<3 and polje[i][j+1]!=0):
						all_shops_i[n_of_shops]=i
						all_shops_j[n_of_shops]=j
						n_of_shops=n_of_shops+1
					elif(j>0 and polje[i][j-1]>0):
						all_shops_i[n_of_shops]=i
						all_shops_j[n_of_shops]=j
						dir_shops[n_of_shops]=true
						n_of_shops=n_of_shops+1
		where_shop=randi()%n_of_shops
		polje[all_shops_i[where_shop]][all_shops_j[where_shop]]=7
	
	
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
				7:
					create_shop(i,j,dir_shops[where_shop])
				9:
					array[i][j]=preload("res://src/levelPieces/exit1.tscn").instance()
					array[i][j].global_position.x=80 + j * 160
					array[i][j].global_position.y=64 + i * 128
					add_child(array[i][j])
				0:
					create_side_room(i,j)


func _ready() -> void:
	create_decorations()
	get_node("BlackScreen").queue_free()
	add_player()

func _process(delta: float) -> void:
	current_time=current_time+delta
	var minutes=floor(current_time/60.0)
	var seconds=int(current_time)%60
	if(seconds>9):
		get_node("Kanvas/UI/time").text=str(minutes)+":"+str(seconds)
	else:
		get_node("Kanvas/UI/time").text=str(minutes)+":0"+str(seconds)

func create_shop(i:int, j:int, dir:bool)->void:
	array[i][j]=preload("res://src/levelPieces/Shop.tscn").instance()
	array[i][j].global_position.x=80 + j * 160
	array[i][j].global_position.y=64 + i * 128
	if(!dir):
		for _i in array[i][j].get_children():
			_i.position.x=-_i.position.x
	add_child(array[i][j])

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
	var flip=randi()%2
	if(flip==0):
		for _i in array[i][j].get_children():
			_i.position.x=-_i.position.x
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
	var flip=randi()%2
	if(flip==0):
		for _i in array[i][j].get_children():
			_i.position.x=-_i.position.x
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
	var flip=randi()%2
	if(flip==0):
		for _i in array[i][j].get_children():
			_i.position.x=-_i.position.x
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
	var flip=randi()%2
	if(flip==0):
		for _i in array[i][j].get_children():
			_i.position.x=-_i.position.x
	add_child(array[i][j])

func create_side_room(i:int, j:int) ->void:
	randomize()
	var room=randi()%7
	match room:
		0:
			array[i][j]=preload("res://src/levelPieces/sideroom1.tscn").instance()
		1:
			if(!dungeon):
				dungeon=true
				array[i][j]=preload("res://src/levelPieces/lootbank.tscn").instance()
			else:
				array[i][j]=preload("res://src/levelPieces/sideroom5.tscn").instance()
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
	var flip=randi()%2
	if(flip==0):
		for _i in array[i][j].get_children():
			_i.position.x=-_i.position.x
	add_child(array[i][j])

func add_player()->void:
	var player = preload("res://src/Actors/Player.tscn").instance()
	player.global_position.x=80+start*160
	player.global_position.y=34
	add_child(player)

func create_decorations()->void:
	var r
	var polje = [[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]]
	for i in range(4):
		for j in range(4):
			r=randi()%3
			if(r==0):
				polje[i][j]=preload("res://src/Other/Fossil.tscn").instance()
				r=randi()%128
				polje[i][j].global_position.x=float(r)+i*160 + 16
				r=randi()%96
				polje[i][j].global_position.y=float(r)+j*128 + 16
				r=randi()%2
				if(r==0):
					polje[i][j].get_node("AnimatedSprite").set_flip_h(true)
				r=randi()%6
				match r:
					0:
						polje[i][j].get_node("AnimatedSprite").animation="an1"
					1:
						polje[i][j].get_node("AnimatedSprite").animation="an2"
					2:
						polje[i][j].get_node("AnimatedSprite").animation="an3"
					3:
						polje[i][j].get_node("AnimatedSprite").animation="an4"
					4:
						polje[i][j].get_node("AnimatedSprite").animation="an5"
					5:
						polje[i][j].get_node("AnimatedSprite").animation="an6"
				add_child(polje[i][j])


