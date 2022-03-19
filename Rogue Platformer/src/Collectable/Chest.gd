extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO
var jump:=150.0
var push:=80.0
var friction:=5.0
var opened:=false

var dropped:=false

var e:=false

func drop_money()->void:
	opened=true
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

func e()->void:
	e=true
	var time_in_seconds = 0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	e=false

func _process(delta: float) -> void:
	if(e and !opened):
		get_node("E").visible=true
	else:
		get_node("E").visible=false

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

func buy()->void:
	drop_money()
	get_node("Closed").visible=false
	get_node("Opened").visible=true

