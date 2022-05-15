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

export var can_be_tnt:=500

export var can_be_spikes:=true
export var can_be_arrow:=true

var outside:bool=false

export var brick_block:=false

onready var level=get_node("/root/Game/World").level

func _ready() -> void:
	#if(global_position.x<0 or global_position.y<0 or global_position.x>616 or global_position.y>604):
	#	outside=true
	
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

func build_dungeon()->void:
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
		if(enemy<groundenemy and n_ground>-1):
			enemy=randi()%10
			if(enemy==0):
				var groundenemy=preload("res://src/Actors/BlackSnake.tscn").instance()
				groundenemy.position.x=global_position.x
				groundenemy.position.y=global_position.y-16
				get_parent().get_parent().add_child(groundenemy)
			else:
				var groundenemy=preload("res://src/Actors/Snake.tscn").instance()
				if(randi()%5==0):
					groundenemy=preload("res://src/Actors/Rat.tscn").instance()
					if(randi()%20==0):
						groundenemy.special=true
				groundenemy.position.x=global_position.x
				groundenemy.position.y=global_position.y-16
				get_parent().get_parent().add_child(groundenemy)
		else:
			var generate_gold=randi()%money
			if(generate_gold<27):
				var value=randi()%750 + add*high_drop
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
					if(randi()%3==0):
						gold=preload("res://src/Collectable/Chest.tscn").instance()
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
	
	if(!up):
		if(randi()%50==0 and can_be_spikes and level>4):
			var trava=preload("res://src/environment/Spikes.tscn").instance()
			trava.position=position
			trava.position.y-=16
			get_parent().add_child(trava)
	
	
	if(up and down and left and right):
		blok = preload("res://src/environment/dirt_tile_mid.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_mid.png")
	elif(up and down and left and !right):
		blok = preload("res://src/environment/dirt_tile_right.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_right.png")
	elif(up and down and !left and right):
		blok = preload("res://src/environment/dirt_tile_left.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_left.png")
	elif(up and down and !left and !right):
		blok = preload("res://src/environment/dirt_tile_left_right.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_right_left.png")
	elif(up and !down and left and right):
		blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_bottom.png")
	elif(up and !down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_bottom_right.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_bottom_right.png")
	elif(up and !down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_bottom_left.png")
	elif(up and !down and !left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_top.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_except_top.png")
	elif(!up and down and left and right): 
		blok = preload("res://src/environment/dirt_tile_top.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_top.png")
	elif(!up and down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_top_right.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungen_tile_top_right.png")
	elif(!up and down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_top_left.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_top_left.png")
	elif(!up and down and !left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_bottom.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_all_except_bottom.png")
	elif(!up and !down and left and right): 
		blok = preload("res://src/environment/dirt_tile_top_bottom.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_top_bottom.png")
	elif(!up and !down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_left.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_all_except_left.png")
	elif(!up and !down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_all_except_right.png")
	else:
		blok = preload("res://src/environment/dir_tile_all.tscn").instance()
		blok.get_node("Dirt").texture=load("res://Assets/TempleBlocks/dungeon_tile_all.png")
	
	blok.position.x=position.x
	blok.position.y=position.y
	
	
	get_parent().add_child(blok)
	queue_free()

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
		if(enemy<groundenemy and n_ground>-1):
			enemy=randi()%15
			if(enemy==-1):
				var groundenemy=preload("res://src/Actors/BlackSnake.tscn").instance()
				groundenemy.position.x=global_position.x
				groundenemy.position.y=global_position.y-16
				get_parent().get_parent().add_child(groundenemy)
			else:
				var groundenemy=preload("res://src/Actors/Snake.tscn").instance()
				groundenemy.position.x=global_position.x
				groundenemy.position.y=global_position.y-16
				get_parent().get_parent().add_child(groundenemy)
		else:
			var generate_gold=randi()%money
			if(generate_gold<27):
				var value=randi()%750 + add*high_drop
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
					if(randi()%3==0):
						gold=preload("res://src/Collectable/Chest.tscn").instance()
					gold.position.x=position.x
					gold.position.y=position.y-16
					get_parent().add_child(gold)
	
	if(down==false):
		randomize()
		var enemy=randi()%n_sky
		if(enemy<skyenemy):
			randomize()
			enemy=randi()%2
			if(level<3):
				enemy=1
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
				if(randi()%2==0 and level==1):
					get_parent().get_parent().add_child(top)
	
	
	
	if(up and down and left and right):
		blok = preload("res://src/environment/dirt_tile_mid.tscn").instance()
	elif(up and down and left and !right):
		blok = preload("res://src/environment/dirt_tile_right.tscn").instance()
	elif(up and down and !left and right):
		blok = preload("res://src/environment/dirt_tile_left.tscn").instance()
	elif(up and down and !left and !right):
		blok = preload("res://src/environment/dirt_tile_left_right.tscn").instance()
	elif(up and !down and left and right):
		blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
	elif(up and !down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_bottom_right.tscn").instance()
	elif(up and !down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
	elif(up and !down and !left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_top.tscn").instance()
	elif(!up and down and left and right): 
		blok = preload("res://src/environment/dirt_tile_top.tscn").instance()
	elif(!up and down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_top_right.tscn").instance()
	elif(!up and down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_top_left.tscn").instance()
	elif(!up and down and !left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_bottom.tscn").instance()
	elif(!up and !down and left and right): 
		blok = preload("res://src/environment/dirt_tile_top_bottom.tscn").instance()
	elif(!up and !down and left and !right): 
		blok = preload("res://src/environment/dirt_tile_all_except_left.tscn").instance()
	elif(!up and !down and !left and right): 
		blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
	else:
		blok = preload("res://src/environment/dir_tile_all.tscn").instance()
	
	blok.position.x=position.x
	blok.position.y=position.y
	
	if(!up):
		var grass=randi()%20
		if(get_node("/root/Game/World").temple or 1==1):
			if(randi()%75==0 and can_be_spikes and level>4):
				var trava=preload("res://src/environment/Spikes.tscn").instance()
				trava.position=position
				trava.position.y-=16
				get_parent().add_child(trava)
		elif(grass==0):
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

func add_temple_money()->void:
	var value=randi()%12
	if(value!=0):
		return
	value=randi()%25
	if(value<5):
		blok.money="min"
		blok.get_node("Money").texture=load("res://Assets/TempleBlocks/gold_tile_min_dungeon.png")
	elif(value<11):
		blok.money="mid"
		blok.get_node("Money").texture=load("res://Assets/TempleBlocks/gold_tile_mid_dungeon.png")
	elif(value<16):
		blok.money="max"
		blok.get_node("Money").texture=load("res://Assets/TempleBlocks/gold_tile_max_dungeon.png")
	elif(value<20):
		blok.money="emerald"
		blok.get_node("Money").texture=load("res://Assets/TempleBlocks/emerald_dungeon.png")
	elif(value<23):
		blok.money="sapphire"
		blok.get_node("Money").texture=load("res://Assets/TempleBlocks/sapphire_dungeon.png")
	else:
		blok.money="ruby"
		blok.get_node("Money").texture=load("res://Assets/TempleBlocks/ruby_dungeon.png")
	

func add_money()->void:
	var value=randi()%12
	if(value!=0):
		value=randi()%10
		if(value!=0):
			return
		match randi()%8:
			0:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_1.png")
			1:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_2.png")
			2:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_3.png")
			3:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_4.png")
			4:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_5.png")
			5:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_6.png")
			6:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_7.png")
			7:
				blok.get_node("Money").texture=load("res://Assets/Rocks/rock_underground_8.png")
		
		return
	value=randi()%25
	if(value<5):
		blok.money="min"
		blok.get_node("Money").texture=load("res://Assets/Blocks/gold_tile_min.png")
	elif(value<11):
		blok.money="mid"
		blok.get_node("Money").texture=load("res://Assets/Blocks/gold_tile_mid.png")
	elif(value<16):
		blok.money="max"
		blok.get_node("Money").texture=load("res://Assets/Blocks/gold_tile_max.png")
	elif(value<20):
		blok.money="emerald"
		blok.get_node("Money").texture=load("res://Assets/Blocks/emerald_underground.png")
	elif(value<23):
		blok.money="sapphire"
		blok.get_node("Money").texture=load("res://Assets/Blocks/sapphire_underground.png")
	else:
		blok.money="ruby"
		blok.get_node("Money").texture=load("res://Assets/Blocks/ruby_underground.png")

func wait()->void:
	var time_in_seconds = 1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	queue_free()


func _physics_process(delta: float) -> void:
	if(get_node("/root/Game/World").temple or get_node("/root/Game").temple):
		brick_block=true
	
	if(brick_block):
		build_dungeon()
		add_temple_money()
	else:
		build_thing()
		add_money()
	var what
	randomize()
	what=randi()%n_boneblock
	if(n_boneblock==-1):
		what=42069
	
	if(randi()%40==0 and what!=42069 and can_be_arrow and level>3 and global_position.y>64):
		if(!$Left.is_colliding() and !$Right.is_colliding()):
			var trap=preload("res://src/environment/ArrowTrap.tscn").instance()
			trap.position.x=position.x
			trap.position.y=position.y
			if(randi()%2==0):
				trap.dir=true
			get_parent().add_child(trap)
			blok.queue_free()
		elif(!$Left.is_colliding()):
			var trap=preload("res://src/environment/ArrowTrap.tscn").instance()
			trap.position.x=position.x
			trap.position.y=position.y
			get_parent().add_child(trap)
			blok.queue_free()
		elif(!$Right.is_colliding()):
			var trap=preload("res://src/environment/ArrowTrap.tscn").instance()
			trap.position.x=position.x
			trap.position.y=position.y
			trap.dir=true
			get_parent().add_child(trap)
			blok.queue_free()
	elif(what==0):
		var bone=preload("res://src/environment/BoneBlock.tscn").instance()
		bone.position.x=position.x
		bone.position.y=position.y
		get_parent().add_child(bone)
		blok.queue_free()
	elif(can_be_tnt>0):
		what=randi()%can_be_tnt
		if(what==0):
			var boom=preload("res://src/environment/TNT.tscn").instance()
			boom.position=position
			get_parent().add_child(boom)
			blok.queue_free()
	queue_free()
