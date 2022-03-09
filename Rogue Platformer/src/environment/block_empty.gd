extends KinematicBody2D

var blok

export var can_destroy=false
export var n=2
export var chanse=1

export var groundenemy=1
export var n_ground=30

export var skyenemy=1
export var n_sky=30

export var n_boneblock=150

export var spider_web=100
export var money=200
export var bonus_money=0

export var add:int=700
export var high_drop:int=0

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

func build_thing()->void:
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
			var generate_gold=randi()%money
			if(generate_gold<27):
				var value=randi()%879 + add*high_drop
				if(value<350):
					var gold=preload("res://src/Collectable/Gold1.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
				elif(value<600):
					var gold=preload("res://src/Collectable/Gold2.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
				elif(value<700):
					var gold=preload("res://src/Collectable/Emerald.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
				elif(value<800):
					var gold=preload("res://src/Collectable/Sapphire.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
				elif(value<880):
					var gold=preload("res://src/Collectable/Ruby.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
				elif(value<1150):
					var gold=preload("res://src/Collectable/Chest.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
				else:
					var gold=preload("res://src/Collectable/Crate.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
	
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
				var set = preload("res://src/environment/SpiderWeb.tscn").instance()
				var web=randi()%8
				set.global_position.x=global_position.x
				set.global_position.y=global_position.y+16
				var top=preload("res://src/Actors/Spider.tscn").instance()
				top.global_position.x=global_position.x
				top.global_position.y=global_position.y+13
				if(web==0):
					set.global_position=top.global_position
					set.global_position.y=global_position.y+16
					get_parent().get_parent().add_child(set)
				get_parent().get_parent().add_child(top)
	
	
	
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
	
	if(!up):
		var grass=randi()%20
		if(grass==0):
			var trava=preload("res://src/Other/Grass.tscn").instance()
			trava.position=position
			trava.position.y-=16
			randomize()
			grass=randi()%5 #je li trava velika
			if(grass==0):
				trava.position.y=trava.position.y+1
				grass=randi()%2
				if(grass==0):
					trava.get_node("AnimatedSprite").animation="an3"
				else:
					trava.get_node("AnimatedSprite").animation="an4"
			else:
				grass=randi()%2
				if(grass==0):
					trava.get_node("AnimatedSprite").animation="an1"
				else:
					trava.get_node("AnimatedSprite").animation="an2"
			get_parent().add_child(trava)
	
	
	get_parent().add_child(blok)
	queue_free()




func _physics_process(delta: float) -> void:
	build_thing()
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
