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
	item.position=position
	get_parent().add_child(item)

