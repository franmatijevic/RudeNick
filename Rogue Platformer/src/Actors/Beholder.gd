extends KinematicBody2D

export var speed: = Vector2(5.0, 1.0)
export var gravity: = 0.0
var using_gravity: = 1

var velocity: = Vector2.ZERO

var health:=20

var player_near:=false

var burst:=false
var bite:=false
var going_down:=false
var k:int=0

var starting_y

func _on_BiteMaybe_body_entered(body: Node) -> void:
	bite()

func _on_Bite_body_entered(body: Node) -> void:
	if(body.name=="Player" and !body.iframes_on):
		body.last_damage="beholder"
		if(body.health<2):
			if(global_position.x<body.global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			body.damage(1)

func _ready() -> void:
	starting_y=global_position.y
	get_node("AnimatedSprite").animation="default"
	get_node("DestroyBlocks").monitoring=true
	gravity=0.0
	#velocity.x=25.0
	#print(velocity.x)

var animation_direction=1

func _process(delta: float) -> void:
	get_node("AnimatedSprite").position.y+=delta*animation_direction*2
	if(get_node("AnimatedSprite").position.y>3):
		animation_direction=-1
	if(get_node("AnimatedSprite").position.y<-3):
		animation_direction=1

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * using_gravity
	if velocity.y > speed.y:
		velocity.y = speed.y
	
	velocity = move_and_slide(velocity)
	
	if($Wall.is_colliding()):
		$Wall.cast_to.x*=-1
		velocity.x*=-1
	
	if(going_down):
		velocity.x=0.001
		global_position.y+=30.0*delta
		if(global_position.y>starting_y+k*256):
			going_down=false
			velocity.x=25
	
	if(get_node("AnimatedSprite").animation=="wink" and get_node("AnimatedSprite").frame==6):
		get_node("AnimatedSprite").animation="default"

func burst()->void:
	if(burst):
		return
	burst=true
	yield(get_tree().create_timer(1), "timeout")
	
	for i in range(10):
		yield(get_tree().create_timer(0.3), "timeout")
		shoot_small_laser()
	burst=false
	if(randi()%3==0):
		k=k+1
		going_down=true
		print("going down")
	if(randi()%3==0):
		get_node("AnimatedSprite").animation="wink"
		get_node("AnimatedSprite").frame=0

func bite()->void:
	if(burst or bite):
		return
	bite=true
	velocity.x=abs(velocity.x)/velocity.x*0.001
	get_node("AnimatedSprite").animation="bite"
	get_node("AnimatedSprite").frame=0
	yield(get_tree().create_timer(0.6), "timeout")
	get_node("Bite").monitoring=true
	get_node("Bite").visible=true
	get_node("BiteMaybe").monitoring=false
	yield(get_tree().create_timer(0.1), "timeout")
	get_node("Bite").monitoring=false
	get_node("BiteMaybe").monitoring=true
	get_node("Bite").visible=false
	bite=false
	get_node("AnimatedSprite").animation="default"
	velocity.x=abs(velocity.x)/velocity.x*25

func shoot_small_laser()->void:
	var laser = preload("res://src/Other/LaserSmall.tscn").instance()
	match randi()%3:
		1:
			laser=preload("res://src/Other/SummonLaser.tscn").instance()
		2:
			laser=preload("res://src/Other/StunLasser.tscn").instance()
	match randi()%9:
		0:
			laser.position.x=-21.5
			laser.position.y=6.5
		1:
			laser.position.x=-40.5
			laser.position.y=-16.5
		2:
			laser.position.x=-25
			laser.position.y=-27.5
		3:
			laser.position.x=-28
			laser.position.y=-48.5
		4:
			laser.position.x=-4
			laser.position.y=-41
		5:
			laser.position.x=8.5
			laser.position.y=-41.5
		6:
			laser.position.x=21-5
			laser.position.y=-40
		7:
			laser.position.x=38
			laser.position.y=-17
		8:
			laser.position.x=41
			laser.position.y=11.5
	laser.position.x+=position.x
	laser.position.y+=position.y
	get_parent().add_child(laser)

func flash_damage()->void:
	var time_in_seconds
	for i in range(5):
		if(i%2==0): modulate.a=0.5
		else: modulate.a=1
		time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")
	modulate.a=1

func damage(value: int)->void:
	health=health-value
	var blood1=preload("res://src/Other/Blood.tscn").instance()
	var blood2=preload("res://src/Other/Blood.tscn").instance()
	blood1.position.y=position.y
	blood1.position.x=position.x-10
	blood2.position.y=position.y
	blood2.position.x=position.x+10
	add_child(blood1)
	add_child(blood2)
	
	if(health<1):
		death()
	flash_damage()



func death():
	pass

func _on_DestroyBlocks_body_entered(body: Node) -> void:
	if(body.name!="Bedrock1" and body.name!="Bedrock2" and body.name!="Bedrock3" and body.name!="Bedrock4"):
		body.destroy()


func _on_Whip_area_entered(area: Area2D) -> void:
	burst()
	damage(1)
	if(randi()%3==0):
		get_node("AnimatedSprite").animation="wink"
		get_node("AnimatedSprite").frame=0



func _on_Player_body_entered(body: Node) -> void:
	if(velocity.x==0):
		velocity.x=25.0
	player_near=true

func _on_Player_body_exited(body: Node) -> void:
	player_near=false
