extends Node2D

var item1
var item2
var item3
var item4

var dir:=false
var purchased:int=0

func _ready() -> void:
	if(dir):
		get_node("Wood4/ItemInShop").position.x*=-1
	create_items()

func count_items()->void:
	if(purchased==3):
		get_node("Wood4/ItemInShop").queue_free()
		var upset
		match randi()%2:
			0:
				upset="Wow, big spender! I'll remember you!"
			1:
				upset="Oh, I won't forget such a wealthy man!"
		get_parent().get_node("Kanvas/UI").print_something(upset)
	purchased+=1

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
	item1.name="item1"
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
	item2.name="item2"
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
	item3.name="item3"
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
	item4.name="item4"
	add_child(item4)

func get_mad()->void:
	get_node("Mole").angry=true
	$DetectDanger.queue_free()
	if(has_node("Wood4/ItemInShop")):
		get_node("Wood4/ItemInShop").queue_free()
	if(has_node("item1")):
		item1.free=true
	if(has_node("item2")):
		item2.free=true
	if(has_node("item3")):
		item3.free=true
	if(has_node("item4")):
		item4.free=true
	get_node("Mole").haty_down=get_node("Mole").haty_down_later
	get_node("Mole").haty_up=get_node("Mole").haty_down_later+1
	get_node("Mole/AnimatedSprite").animation="walking"
	get_node("Mole/Shotgun").visible=true
	get_node("Mole").velocity.x=get_node("Mole").speed.x
	get_node("Mole/DetectPlayer").monitoring=true
	get_node("Mole/DamagePlayer").monitoring=true
	get_node("Mole/GunSight").enabled=true
	
	var upset:String="Sad sam jako razocaran!"
	match randi()%6:
		0:
			upset="You thief! You will pay for this!"
		1:
			upset="You filthy human! Stop!"
		2:
			upset="A criminal on the loose! Halt!"
		3:
			upset="A robber! I will show no mercy..."
		4:
			upset="A terrorist? In my shop? No way..."
		5:
			upset="You monster! It's over for you now!"
	
	get_parent().get_node("Kanvas/UI").print_something(upset)

func steal_all()->void:
	if(has_node("item1")):
		item1.get_for_free()
	if(has_node("item2")):
		item2.get_for_free()
	if(has_node("item3")):
		item3.get_for_free()
	if(has_node("item4")):
		item4.get_for_free()

func _on_DetectDanger_area_entered(area: Area2D) -> void:
	get_mad()

func _on_DetectDanger_body_entered(body: Node) -> void:
	get_mad()
