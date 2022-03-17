extends Node2D

var item

func _ready() -> void:
	var chance=randi()%5
	if(chance<2):
		item=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item=preload("res://src/Items/BuyBeans.tscn").instance()
	item.global_position.x=global_position.x
	item.global_position.y=global_position.y
	#print("x",position.x-item.position.x)
	#print("y",position.y-item.position.y)
	#get_parent().add_child(item)

