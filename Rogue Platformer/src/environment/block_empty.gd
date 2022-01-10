extends KinematicBody2D

export var can_destroy=false
export var n=2
export var chanse=1

export var groundenemy=1
export var n_ground=30

export var skyenemy=1
export var n_sky=35

func _ready() -> void:
	if(can_destroy==true):
		randomize()
		var destroy=randi()%n
		if(destroy<chanse):
			queue_free()



func _physics_process(delta: float) -> void:
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
	if(down==false):
		randomize()
		var enemy=randi()%n_sky
		if(enemy<skyenemy):
			var top=preload("res://src/Actors/Bat.tscn").instance()
			top.position.x=global_position.x
			top.position.y=global_position.y+15
			get_parent().get_parent().add_child(top)
	
	
	if(up and down and left and right):
		var blok = preload("res://src/environment/dirt_tile_mid.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		get_parent().add_child(blok)
	elif(up and down and left and !right):
		var blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=270
		get_parent().add_child(blok)
	elif(up and down and !left and right):
		var blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=90
		get_parent().add_child(blok)
	elif(up and down and !left and !right):
		var blok = preload("res://src/environment/dirt_tile_top_bottom.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=90
		get_parent().add_child(blok)
	elif(up and !down and left and right):
		var blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		get_parent().add_child(blok)
	elif(up and !down and left and !right): 
		var blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=270
		get_parent().add_child(blok)
	elif(up and !down and !left and right): 
		var blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		get_parent().add_child(blok)
	elif(up and !down and !left and !right): 
		var blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=270
		get_parent().add_child(blok)
	elif(!up and down and left and right): 
		var blok = preload("res://src/environment/dirt_tile_bottom.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=180
		get_parent().add_child(blok)
	elif(!up and down and left and !right): 
		var blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=180
		get_parent().add_child(blok)
	elif(!up and down and !left and right): 
		var blok = preload("res://src/environment/dirt_tile_bottom_left.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=90
		get_parent().add_child(blok)
	elif(!up and down and !left and !right): 
		var blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=90
		get_parent().add_child(blok)
	elif(!up and !down and left and right): 
		var blok = preload("res://src/environment/dirt_tile_top_bottom.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		get_parent().add_child(blok)
	elif(!up and !down and left and !right): 
		var blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		blok.rotation_degrees=180
		get_parent().add_child(blok)
	elif(!up and !down and !left and right): 
		var blok = preload("res://src/environment/dirt_tile_all_except_right.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		get_parent().add_child(blok)
	else:
		var blok = preload("res://src/environment/dir_tile_all.tscn").instance()
		blok.position.x=position.x
		blok.position.y=position.y
		get_parent().add_child(blok)
	
	queue_free()
