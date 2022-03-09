extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO
var jump:=150.0
var push:=80.0
var friction:=5.0
var opened:=false

var dropped:=false

func drop_money()->void:
	var gold=randi()%10
	var money=[0,0,0]
	if(gold<3):
		money[1]=preload("res://src/Collectable/Emerald.tscn").instance()
	elif(gold<7):
		money[1]=preload("res://src/Collectable/Sapphire.tscn").instance()
	else:
		money[1]=preload("res://src/Collectable/Ruby.tscn").instance()
	money[1].position=position
	money[1].velocity.y=0.0
	money[1].velocity.x+=20.0
	get_parent().add_child(money[1])
	
	gold=randi()%10
	if(gold<3):
		money[2]=preload("res://src/Collectable/Emerald.tscn").instance()
	elif(gold<7):
		money[2]=preload("res://src/Collectable/Sapphire.tscn").instance()
	else:
		money[2]=preload("res://src/Collectable/Ruby.tscn").instance()
	money[2].position=position
	money[2].velocity.y=0.0
	money[2].velocity.x-=20.0
	get_parent().add_child(money[2])

func _on_DetectWhip_area_entered(area: Area2D) -> void:
	if(!dropped):
		dropped=true
		drop_money()
	if(!opened):
		get_node("Closed").visible=false
		get_node("Opened").visible=true
	
	if(velocity.x!=0.0):
		return
	if(!velocity.y<0.0):
		velocity.y-=jump
	if(area.global_position.x>global_position.x):
		velocity.x-=push
	else:
		velocity.x+=push


func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y
	
	if(velocity.x>speed.x):
		velocity.x=speed.x
	if(velocity.x<-speed.x):
		velocity.x=-speed.x
	
	if(velocity.x>0.0 and !velocity.y<0.0):
		velocity.x-=friction
	if(velocity.x<0.0 and !velocity.y<0.0):
		velocity.x+=friction
