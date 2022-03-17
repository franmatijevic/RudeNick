extends Node2D

var item1
var item2
var item3
var item4

var dir:=false

func _ready() -> void:
	create_items()

func create_items()->void:
	var chance=randi()%5
	if(chance<2):
		item1=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item1=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item1=preload("res://src/Items/BuyBeans.tscn").instance()
	item1.position.y=0.0
	item1.position.x=16
	add_child(item1)
	chance=randi()%5
	if(chance<2):
		item2=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item2=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item2=preload("res://src/Items/BuyBeans.tscn").instance()
	item2.position.y=0.0
	item2.position.x=0
	add_child(item2)
	chance=randi()%5
	if(chance<2):
		item3=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item3=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item3=preload("res://src/Items/BuyBeans.tscn").instance()
	item3.position.x=-16
	item3.position.y=0.0
	print(item3.global_position)
	add_child(item3)
	chance=randi()%5
	if(chance<2):
		item4=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item4=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item4=preload("res://src/Items/BuyBeans.tscn").instance()
	item4.position.y=0.0
	if(!dir):
		item4.position.x=32
	else:
		item4.position.x=-32
	add_child(item4)
