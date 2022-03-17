extends Node2D

var item1
var item2
var item3
var item4

# Called when the node enters the scene tree for the first time.
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
	item1.position=position
	item1.position.x=position.x-32
	add_child(item1)
	chance=randi()%5
	if(chance<2):
		item2=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item2=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item2=preload("res://src/Items/BuyBeans.tscn").instance()
	item2.position=position
	item2.position.x=position.x-8
	add_child(item2)
	chance=randi()%5
	if(chance<2):
		item3=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item3=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item3=preload("res://src/Items/BuyBeans.tscn").instance()
	item3.position=position
	print(item3.global_position)
	add_child(item3)
	chance=randi()%5
	if(chance<2):
		item4=preload("res://src/Items/BuyRope.tscn").instance()
	elif(chance<4):
		item4=preload("res://src/Items/BuyBomb.tscn").instance()
	else:
		item4=preload("res://src/Items/BuyBeans.tscn").instance()
	item4.position=position
	item4.position.x=position.x+8
	add_child(item4)

func _process(delta: float) -> void:
	pass
	#print(item3.global_position)
