extends "res://src/Actors/Actor.gd"

export var max_jump:=200

var angry:=false
export var idle_angry:=false

var haty_down:=0.0
var haty_up:=0.0
var haty_down_later=0.0
var hat_n:bool=false
var health:int=6

var last_damage="Mole"

var turn_to_player:bool=false
var can_shoot:bool=true
var look_around_idle:=false

var can_move:int=1

func _on_DetectPlayer_body_entered(body: Node) -> void:
	if(body.global_position.y<global_position.y and !body.if_stunned):
		if(velocity.y<0):
			velocity.y=-velocity.y
		flash_damage()
		body.enemy_jump()
		if(health>1):
			health=health-1
			var blood=preload("res://src/Other/Blood.tscn").instance()
			blood.global_position=global_position
			blood.get_node("Particles2D").amount=int(25)
			add_child(blood)
		else:
			death()

func _on_DamagePlayer_body_entered(body: Node) -> void:
	if(!body.iframes_on and body.global_position.y>global_position.y):
		body.last_damage=last_damage
		if(body.health<2):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			if(!body.iframes_on):
				body.damage(1)

func _on_Whip_area_entered(area: Area2D) -> void:
	if(health==1):
		death()
	
	if(!angry):
		get_parent().get_mad()
	health=health-1
	flash_damage()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	blood.get_node("Particles2D").amount=int(25)
	add_child(blood)

func _on_IdlePlayer_body_entered(body: Node) -> void:
	if(get_parent().name=="Shop"):
		get_parent().make_free()
	
	angry=true
	idle_angry=false
	get_node("IdlePlayer").monitoring=false
	haty_down=haty_down_later
	haty_up=haty_down_later+1
	get_node("AnimatedSprite").animation="walking"
	if(body.global_position.x>global_position.x):
		velocity.x=speed.x
	else: 
		velocity.x=-speed.x
	get_node("DetectPlayer").monitoring=true
	get_node("DamagePlayer").monitoring=true
	get_node("GunSight").enabled=true

func _ready() -> void:
	get_node("AnimatedSprite").animation="default"
	get_node("Shotgun").set_flip_h(get_node("AnimatedSprite").is_flipped_h())
	if(idle_angry):
		get_node("Shotgun").visible=true
		get_node("AnimatedSprite").animation="idle"
		get_node("IdlePlayer").monitoring=true
		if(get_parent().name=="Shop"):
			get_parent().get_node("Welcome").monitoring=false
	
	var pickhat=randi()%2
	var hat = get_node("AnimatedSprite/Hats")
	match pickhat:
		0:
			hat.animation="hat0"
			hat.position.x=-0.5
			haty_up=-4.5
			haty_down=haty_up+1
			haty_down_later=-5.5
			hat_n=false
		1:
			hat.animation="hat1"
			hat.position.x=-0.5
			haty_up=-0.5
			haty_down=haty_up+1
			haty_down_later=-1.5
			hat_n=true
		2:
			get_node("AnimatedSprite/Hats").animation="hat2"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		3:
			get_node("AnimatedSprite/Hats").animation="hat3"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		4:
			get_node("AnimatedSprite/Hats").animation="hat4"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		5:
			get_node("AnimatedSprite/Hats").animation="hat5"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		6:
			get_node("AnimatedSprite/Hats").animation="hat6"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		7:
			get_node("AnimatedSprite/Hats").animation="hat7"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		8:
			get_node("AnimatedSprite/Hats").animation="hat8"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		9:
			get_node("AnimatedSprite/Hats").animation="hat9"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
	haty_down=haty_up+1

func _process(delta: float) -> void:
	if(hat_n):
		get_node("AnimatedSprite/Hats").set_flip_h(get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite/Hats").position.x=abs(get_node("AnimatedSprite/Hats").position.x)
	else:
		get_node("AnimatedSprite/Hats").position.x=-abs(get_node("AnimatedSprite/Hats").position.x)
		get_node("AnimatedSprite/Hats").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
	
	if(!angry):
		if(get_node("AnimatedSprite").frame==0):
			get_node("AnimatedSprite/Hats").position.y=haty_up
		else:
			get_node("AnimatedSprite/Hats").position.y=haty_down
	elif(idle_angry):
		idle_look_around()
	else:
		if(get_node("AnimatedSprite").frame==0):
			get_node("AnimatedSprite/Hats").position.y=haty_down_later+1
		else:
			get_node("AnimatedSprite/Hats").position.y=haty_down_later
		if(!turn_to_player):
			look_for_player()
		if(velocity.x>0.0):
			get_node("AnimatedSprite").set_flip_h(false)
			get_node("Shotgun").set_flip_h(false)
			$GunSight.cast_to.x=88
		else:
			$GunSight.cast_to.x=-88
			get_node("AnimatedSprite").set_flip_h(true)
			get_node("Shotgun").set_flip_h(true)

func _physics_process(delta: float) -> void:
	if(angry and !idle_angry):
		if(is_on_wall()):
			velocity.x=-velocity.x
		if(get_node("/root/Game/World").has_node("Player")):
			if(get_node("/root/Game/World/Player").global_position.y+2<global_position.y):
				jump()
		
		if($GunSight.is_colliding() and can_shoot):
			shoot()
	velocity.y = move_and_slide(velocity*can_move, can_move*Vector2.UP*gravity*delta).y

func idle_look_around()->void:
	if(!look_around_idle):
		look_around_idle=true
		yield(get_tree().create_timer(9), "timeout")
		get_node("AnimatedSprite").set_flip_h(get_node("AnimatedSprite").is_flipped_h())
		look_around_idle=false


func damage(value: int)->void:
	if(health<=value):
		death()
	flash_damage()
	health=health-value
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	blood.get_node("Particles2D").amount=int(25)
	add_child(blood)

func jump()->void:
	if(is_on_floor()):
		if(get_node("/root/Game/World/Player").global_position.y<global_position.y-32):
			velocity.y-=max_jump
		else:
			velocity.y-=max_jump/1.2

func shoot()->void:
	can_shoot=false
	var bullet=preload("res://src/Other/Bullet.tscn").instance()
	bullet.position=position
	
	if(velocity.x<0):
		bullet.speed=-bullet.speed
	get_parent().add_child(bullet)
	var time_in_seconds = 1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	can_shoot=true

func look_for_player()->void:
	turn_to_player=true
	var time_in_seconds = 1.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	if(get_node("/root/Game/World").has_node("Player")):
		if(get_node("/root/Game/World/Player").global_position.x>global_position.x):
			velocity.x=abs(velocity.x)
		else:
			velocity.x=-abs(velocity.x)
	turn_to_player=false

func death()->void:
	get_node("/root/Game/World/Kanvas/UI/MoleIcon").visible=false
	get_node("/root/Game").shop_angry=0
	print("now is angry 0")
	get_node("DamagePlayer").queue_free()
	get_node("DetectPlayer").queue_free()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	blood.get_node("Particles2D").amount=int(25)
	get_parent().add_child(blood)
	var gun = preload("res://src/Items/Shotgun.tscn").instance()
	gun.position=position
	get_parent().add_child(gun)
	queue_free()

func flash_damage()->void:
	var time_in_seconds
	for i in range(5):
		if(i%2==0): modulate.a=0.5
		else: modulate.a=1
		time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")
	modulate.a=1


func _on_Web_body_entered(body: Node) -> void:
	can_move=0


func _on_Web_body_exited(body: Node) -> void:
	can_move=1
