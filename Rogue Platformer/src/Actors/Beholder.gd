extends KinematicBody2D

var velocity: = Vector2.ZERO

var health:int=85
var maks:int=85
var speed:float=0.0
var more_big_laser:=0

var player_near:=false

var dead:=false

var burst:=false
var bite:=false
var going_down:=false

var leftright:=false

var k:int=0

var starting_y

var time:float=0.0

var last_damage:String="beholder"

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
	health=maks
	starting_y=global_position.y
	get_node("AnimatedSprite").animation="default"
	speed=25.0
	#velocity.x=25.0
	#print(velocity.x)

var animation_direction=1

func _process(delta: float) -> void:
	if(abs(velocity.x)>1):
		time+=delta
	if(time>12):
		time=-3
		get_node("AnimatedSprite").animation="talking"
		match randi()%10:
			0:
				get_node("iwin").play()
			1:
				get_node("laugh1").play()
			2:
				get_node("laugh2").play()
			3:
				get_node("nomatch").play()
			4:
				get_node("run_weak").play()
			5:
				get_node("fool").play()
			6:
				get_node("run").play()
			7:
				get_node("aaa").play()
			8:
				get_node("hope").play()
			9:
				get_node("beware").play()
	
	if(time>-1 and time<0):
		get_node("AnimatedSprite").animation="default"
	
	if(!dead):
		get_node("AnimatedSprite").position.y+=delta*animation_direction*2
		if(get_node("AnimatedSprite").position.y>3):
			animation_direction=-1
		if(get_node("AnimatedSprite").position.y<-3):
			animation_direction=1
	if(leftright):
		get_node("AnimatedSprite").position.x+=delta*animation_direction*40
		if(get_node("AnimatedSprite").position.x>0.75):
			animation_direction=-1
		if(get_node("AnimatedSprite").position.x<-0.75):
			animation_direction=1

var shoot:float=0

func _physics_process(delta: float) -> void:
	if(player_near and !dead):
		shoot+=delta
		if(shoot>3.0):
			shoot=0.0
			shoot_small_laser()
			if(randi()%2==0):
				shoot_small_laser()
				if(randi()%2==0):
					shoot_small_laser()
	
	
	velocity = move_and_slide(velocity)
	
	
	if(position.x<688):
		velocity.x=abs(velocity.x)
	if(position.x>1104):
		velocity.x=-abs(velocity.x)
	
	
	
	if(going_down):
		velocity.x=0.001
		global_position.y-=30.0*delta
		if(global_position.y<starting_y-k*100):
			going_down=false
			velocity.x=speed
	
	
	if(get_node("AnimatedSprite").animation=="wink" and get_node("AnimatedSprite").frame==6):
		get_node("AnimatedSprite").animation="default"

func burst()->void:
	if(burst):
		return
	burst=true
	yield(get_tree().create_timer(1), "timeout")
	
	for i in range(10):
		if(dead):
			return
		yield(get_tree().create_timer(0.3), "timeout")
		shoot_small_laser()
	burst=false
	if(randi()%3==0):
		get_node("AnimatedSprite").animation="wink"
		get_node("AnimatedSprite").frame=0

func big_laser(more_laser:int)->void:
	if(burst):
		return
	burst=true
	if(velocity.x!=0):
		velocity.x=abs(velocity.x)/velocity.x*0.001
	else:
		velocity.x=0.001
	yield(get_tree().create_timer(0.25), "timeout")
	get_node("BigLaser").play()
	get_node("Charge").visible=true
	get_node("Charge").frame=0
	
	if(dead):
		get_node("BigLaser").stop()
		get_node("Charge").visible=false
		return
	
	yield(get_tree().create_timer(2), "timeout")
	var laser=preload("res://src/Other/BigLaser.tscn").instance()
	get_node("BigLaser").stop()
	laser.position=position
	get_parent().add_child(laser)
	get_node("Charge").visible=false
	burst=false
	if(velocity.x!=0):
		velocity.x=abs(velocity.x)/velocity.x*speed
	if(randi()%5-more_laser<-1):
		big_laser(more_laser)


func bite()->void:
	if(dead):
		return
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
	if(dead):
		return
	get_node("AnimatedSprite").animation="default"
	velocity.x=abs(velocity.x)/velocity.x*speed

func shoot_small_laser()->void:
	if(dead):
		return
	var laser = preload("res://src/Other/LaserSmall.tscn").instance()
	if(randi()%6==0):
		laser=preload("res://src/Other/SummonLaser.tscn").instance()
	elif(randi()%4==0):
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
	if(randi()%50==0):
		var meat=preload("res://src/Collectable/RatMeat.tscn").instance()
		meat.global_position=global_position
		get_parent().add_child(meat)
	
	health=health-value
	get_node("/root/Game/World/Kanvas/UI/HPbeholder").value=health
	var blood1=preload("res://src/Other/Blood.tscn").instance()
	var blood2=preload("res://src/Other/Blood.tscn").instance()
	blood1.position.y=position.y
	blood1.position.x=position.x-10
	blood2.position.y=position.y
	blood2.position.x=position.x+10
	add_child(blood1)
	add_child(blood2)
	
	if(health<maks/2):
		speed=35.0
	if(health<maks/4):
		speed=50.0
	if(health<18):
		more_big_laser=1
	
	
	if(health<1):
		death()
	flash_damage()
	if(k!=2 and health<maks-k*30-20):
		k=k+1
		going_down=true
	
	if(value>3 and randi()%3==0):
		big_laser(2)
	
	if(randi()%3!=0):
		return
	if(randi()%4-more_big_laser<1):
		big_laser(0)
		return
	burst()


func death():
	if(dead):
		return
	
	get_node("Camera2D").limit_top=get_node("/root/Game/World/Player/Camera2D").limit_top
	get_node("Camera2D").limit_right=get_node("/root/Game/World/Player/Camera2D").limit_right
	get_node("Camera2D").limit_left=get_node("/root/Game/World/Player/Camera2D").limit_left
	get_node("Camera2D").limit_bottom=get_node("/root/Game/World/Player/Camera2D").limit_bottom
	
	get_node("/root/Game/World/Music1").stop()
	get_node("/root/Game/World/Music1").volume_db=-80
	
	get_node("Whip").monitoring=false
	get_node("/root/Game").can_pause=false
	
	get_node("/root/Game/World/Player").velocity.x=0.0
	get_node("/root/Game/World/Player").ledge_grab=false
	get_node("/root/Game/World/Player").using_gravity=1
	get_node("/root/Game/World/Player").move_horizontal=0
	
	get_node("/root/Game").total_time+=get_node("/root/Game/World").current_time
	
	velocity.x=0.0
	velocity.y=0.0
	going_down=0.0
	
	#get_node("/root/Game/World/Player").gravity=0.0
	get_node("/root/Game/World/Player").speed.x=0.0
	
	get_node("AnimatedSprite").animation="idle"
	dead=true
	get_node("/root/Game/World/Kanvas/UI").visible=false
	get_node("/root/Game/World/Player").health=99
	get_node("Camera2D").current=true
	
	yield(get_tree().create_timer(1), "timeout")
	get_node("DestroyBlocks").monitoring=true
	
	yield(get_tree().create_timer(1), "timeout")
	
	leftright=true
	yield(get_tree().create_timer(3), "timeout")
	get_node("spooky").play()
	yield(get_tree().create_timer(1), "timeout")
	get_node("spooky").stop()
	get_node("Death1").play()
	get_node("Death2").play()
	
	get_node("AnimatedSprite").animation="death"
	
	yield(get_tree().create_timer(4), "timeout")
	
	
	var credits=preload("res://src/Levels/Credits.tscn").instance()
	credits.in_game=true
	credits.total_score=get_node("/root/Game/World/Player").money
	credits.total_time=get_node("/root/Game").total_time
	credits.total_levels=get_node("/root/Game/World").level
	get_node("/root/Game").add_child(credits)
	get_node("/root/Game/World").visible=false
	get_node("/root/Game/World").queue_free()

func _on_DestroyBlocks_body_entered(body: Node) -> void:
	if(body.name!="Bedrock1" and body.name!="Bedrock2" and body.name!="Bedrock3" and body.name!="Bedrock4"):
		body.destroy()


func _on_Whip_area_entered(area: Area2D) -> void:
	if(dead):
		return
	if(randi()%3==0):
		get_node("AnimatedSprite").animation="wink"
		get_node("AnimatedSprite").frame=0
	damage(1)


func _on_Player_body_entered(body: Node) -> void:
	if(velocity.x==0):
		velocity.x=speed
	player_near=true

func _on_Player_body_exited(body: Node) -> void:
	player_near=false


func _on_EpicStuff_body_entered(body: Node) -> void:
	get_node("AnimatedSprite").animation="talking"
	get_node("EpicStuff").monitoring=false
	get_node("EpicStuff").queue_free()
	get_node("/root/Game/World/Kanvas/UI/Darkness").visible=false
	get_node("/root/Game/World/Kanvas/UI/DarknessBoss").visible=false
	get_node("/root/Game/World/Music1").play()
	get_node("/root/Game/World/Kanvas/UI/HPbeholder").visible=true
	get_node("/root/Game/World/Kanvas/UI/BossHealthBar").visible=true
	get_node("/root/Game/World/Kanvas/UI/Boss_name").visible=true
	match randi()%2:
		0:
			get_node("run").play()
		1:
			get_node("beware").play()
	
