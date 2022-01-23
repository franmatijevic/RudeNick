extends KinematicBody2D

var blok

export var can_destroy=false
export var n=2
export var chanse=1

export var groundenemy=1
export var n_ground=30

export var skyenemy=1
export var n_sky=30

export var n_boneblock=100

export var spider_web=70

func _ready() -> void:
	if(can_destroy==true):
		randomize()
		var destroy=randi()%n
		if(destroy<chanse):
			queue_free()

func add_web(direction: int)->void:
	var web = preload("res://src/environment/SpiderWeb.tscn").instance()
	match direction:
		0: #up
			web.global_position.x=global_position.x
			web.global_position.y=global_position.y-16
		1: #down
			web.global_position.x=global_position.x
			web.global_position.y=global_position.y+16
		2: #left
			web.global_position.x=global_position.x-16
			web.global_position.y=global_position.y
		3: #right
			web.global_position.x=global_position.x+16
			web.global_position.y=global_position.y
	get_parent().get_parent().add_child(web)

func build_thig()->void:
	var up=false
	var down=false
	var left=false
	var right=false
	
	if(global_position.x==8):
		left=true
	if(global_position.x==632):
		right=true
	if(global_position.y==8):
		up=true
	if(global_position.y==504):
		down=true
	
	if($Up.is_colliding()): up=true
	if($Down.is_colliding()): down=true
	if($Left.is_colliding()): left=true
	if($Right.is_colliding()): right=true
	
	if(up==false):
		randomize()
		var enemy=randi()%n_ground
		if(enemy<groundenemy):
			var groundenemy=preload("res://src/Actors/Snake.tscn").instance()
			groundenemy.position.x=global_position.x
			groundenemy.position.y=global_position.y-16
			get_parent().get_parent().add_child(groundenemy)
		else:
			enemy=randi()%spider_web*3
			if(enemy==0):
				add_web(0)
	
	if(!left):
		var addweb=randi()%spider_web
		if(addweb==0):
			add_web(2)
	
	if(!right):
		var addweb=randi()%spider_web
		if(addweb==0):
			add_web(3)
	
	if(down==false):
		randomize()
		var enemy=randi()%n_sky
		if(enemy<skyenemy):
			randomize()
			enemy=randi()%2
			if(enemy==0):
				var top=preload("res://src/Actors/Bat.tscn").instance()
				top.global_position.x=global_position.x
				top.global_position.y=global_position.y+15
				get_parent().get_parent().add_child(top)
			else:
				var top=preload("res://src/Actors/Spider.tscn").instance()
				top.global_position.x=global_position.x
				top.global_position.y=global_position.y+13
				get_parent().get_parent().add_child(top)
		else:
			enemy=randi()%spider_web
			if(enemy==0):
				add_web(1)
	
	
	
	if(up and down and left and right):
		blok = preload("res://src/environment/dirt_tile_mid.tscn").instance()
	elif(up and down and left and !right):
		blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.rotation_degrees=270
	elif(up and down and !left and right):
		blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.rotation_degrees=90
	elif(up and down and !left and !right):
		blok = preload("res://src/environment/dirt_tile_top_bottom.tscn").instance()
		blok.rotation_degrees=90
	elif(up and !down and left and right):
		blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
	elif(up and !down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.rotation_degrees=270
	elif(up and !down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
	elif(up and !down and !left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.rotation_degrees=270
	elif(!up and down and left and right): 
		blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.rotation_degrees=180
	elif(!up and down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.rotation_degrees=180
	elif(!up and down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.rotation_degrees=90
	elif(!up and down and !left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.rotation_degrees=90
	elif(!up and !down and left and right): 
		blok = preload("res://src/environment/dirt_tile_top_bottom.tscn").instance()
	elif(!up and !down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.rotation_degrees=180
	elif(!up and !down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
	else:
		blok = preload("res://src/environment/dir_tile_all.tscn").instance()
	
	blok.position.x=position.x
	blok.position.y=position.y
	get_parent().add_child(blok)
	
	
	queue_free()

func _physics_process(delta: float) -> void:
	build_thig()
	var what
	randomize()
	what=randi()%n_boneblock
	if(what==0):
		var bone=preload("res://src/environment/BoneBlock.tscn").instance()
		bone.position.x=position.x
		bone.position.y=position.y
		get_parent().add_child(bone)
		blok.queue_free()
	
	queue_free()
