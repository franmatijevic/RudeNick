extends Node2D

var item1
var item2
var item3
var item4

var dir:=false
var purchased:int=0

var very_angry:=false

func _ready() -> void:
	if(dir):
		get_node("Wood4/ItemInShop").position.x*=-1
	create_items()
	if(get_node("/root/Game").shop_angry>0):
		get_node("Mole").idle_angry=true
		get_node("Mole/IdlePlayer").monitoring=true
		get_node("Mole/IdlePlayer").position=position
		get_node("Mole/Shotgun").visible=true
		get_node("Welcome").queue_free()

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
	get_node("Sound").play()

func create_items()->void:
	item1 = load(find_item()).instance()
	item1.position.y=0.0
	item1.position.x=16
	item1.name="item1"
	add_child(item1)
	item2=load(find_item()).instance()
	item2.position.y=0.0
	item2.position.x=0
	item2.name="item2"
	add_child(item2)
	item3=load(find_item()).instance()
	item3.position.x=-16
	item3.position.y=0.0
	item3.name="item3"
	add_child(item3)
	
	item4 = load(find_item()).instance()
	item4.position.y=0.0
	if(!dir):
		item4.position.x=32
	else:
		item4.position.x=-32
	item4.name="item4"
	add_child(item4)

func find_item()->String:
	var chance=randi()%20
	#rope 25% 5/20
	#bomb 25% 5/20
	#meat 25% 5/20
	#beans 10% 2/20
	#cure 10% 2/20
	#goggles 5% 1/20
	
	if(chance<5): #0,1,2,3,4
		return "res://src/Items/BuyRope.tscn"
	elif(chance<10): #5,6,7,8,9
		return "res://src/Items/BuyBomb.tscn"
	elif(chance<15): #10,11,12,13,14
		return "res://src/Items/BuyMeat.tscn"
	elif(chance<17): #15,16
		return "res://src/Items/BuyBeans.tscn"
	elif(chance<19): #17, 18
		return "res://src/Items/Cure.tscn"
	else: #19
		return "res://src/Items/Goggles.tscn"

func get_mad()->void:
	get_node("/root/Game/World").raging_music()
	get_node("/root/Game/World/Kanvas/UI/MoleIcon").visible=true
	get_node("Mole").scream()
	if(!has_node("Mole")):
		return
	if(has_node("DetectDanger")):
		get_node("DetectDanger").queue_free()
	if(has_node("Welcome")):
		get_node("Welcome").queue_free()
	if(very_angry):
		print("now is angry 5")
		get_node("/root/Game").shop_angry=5
	else:
		print("now is angry 2")
		get_node("/root/Game").shop_angry=2
	get_node("Mole").angry=true
	make_free()
	get_node("Mole").haty_down=get_node("Mole").haty_down_later
	get_node("Mole").haty_up=get_node("Mole").haty_down_later+1
	get_node("Mole/AnimatedSprite").animation="walking"
	get_node("Mole/Shotgun").visible=true
	get_node("Mole").velocity.x=get_node("Mole").speed.x
	get_node("Mole/DetectPlayer").monitoring=true
	get_node("Mole/DamagePlayer").monitoring=true
	get_node("Mole/GunSight").enabled=true
	
	var upset:String="Sad sam jako razocaran!"
	match randi()%7:
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
		6:
			upset="An imposter! Very sus!"
	
	get_parent().get_node("Kanvas/UI").print_something(upset)

func make_free()->void:
	if(has_node("DetectPlayer")):
		$DetectDanger.queue_free()
	if(has_node("Wood4/ItemInShop")):
		get_node("Wood4/ItemInShop").queue_free()
	if(has_node("item1")):
		item1.free=true
		item1.get_node("E").scale.x=0
		item1.get_node("E").scale.y=0
		item1.get_node("Text").scale.x=0
		item1.get_node("Text").scale.y=0
	get_node("Sound").volume_db=-80
	if(has_node("item2")):
		item2.free=true
		item2.get_node("E").scale.x=0
		item2.get_node("E").scale.y=0
		item2.get_node("Text").scale.x=0
		item2.get_node("Text").scale.y=0
	if(has_node("item3")):
		item3.free=true
		item3.get_node("E").scale.x=0
		item3.get_node("E").scale.y=0
		item3.get_node("Text").scale.x=0
		item3.get_node("Text").scale.y=0
	if(has_node("item4")):
		item4.free=true
		item4.get_node("E").scale.x=0
		item4.get_node("E").scale.y=0
		item4.get_node("Text").scale.x=0
		item4.get_node("Text").scale.y=0


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


func _on_Welcome_body_entered(body: Node) -> void:
	get_node("Welcome").queue_free()
	var hello="Welcome to "
	match randi()%55:
		0: hello+="Moyt"
		1: hello+="Jotaro"
		2: hello+="Frank"
		3: hello+="Igor"
		4: hello+="Iggy"
		5: hello+="Ivan"
		6: hello+="Noah"
		7: hello+="Elijah"
		8: hello+="Oliver"
		9: hello+="Windy"
		10: hello+="Violet"
		11: hello+="Mark"
		12: hello+="Derek"
		13: hello+="Josuke"
		14: hello+="Giorno"
		15: hello+="Luna"
		16: hello+="Sam"
		17: hello+="Ava"
		18: hello+="Charlotte"
		19: hello+="Liam"
		20: hello+="Olga"
		21: hello+="Zion"
		22: hello+="Lee"
		23: hello+="Jake"
		24: hello+="Thor"
		25: hello+="Karen"
		26: hello+="Tyler"
		27: hello+="Dubravka"
		28: hello+="Sophia"
		29: hello+="Blair"
		30: hello+="Blaze"
		31: hello+="Juan"
		32: hello+="Luciana"
		33: hello+="Diego"
		34: hello+="Jonathan"
		35: hello+="Joseph"
		36: hello+="Jolyne"
		37: hello+="Johnny"
		38: hello+="Hiroto"
		39: hello+="Dilara"
		40: hello+="Ben"
		41: hello+="Benjamin"
		42: hello+="Franklin"
		43: hello+="Toby"
		44: hello+="Alexandar"
		45: hello+="Alex"
		46: hello+="Alexa"
		47: hello+="Alice"
		48: hello+="Zelda"
		49: hello+="Edward"
		50: hello+="Kamala"
		51: hello+="Leith"
		52: hello+="Arya"
		53: hello+="Fay"
		54: hello+="Azra"
	
	match randi()%3:
		0:
			hello+="s Shop! How can I help you?"
		1:
			hello+="s Shop! What can I do for you?"
		2: 
			hello+="s Shop! May I help you?"
	get_parent().get_node("Kanvas/UI").print_something(hello)
