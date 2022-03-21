extends "res://src/Actors/Actor.gd"

export var max_jump:=200

var angry:=false
var haty_down:=0.0
var haty_up:=0.0

var turn_to_player:bool=false
var can_shoot:bool=true

func _ready() -> void:
	get_node("AnimatedSprite").animation="default"
	get_node("Shotgun").set_flip_h(get_node("AnimatedSprite").is_flipped_h())
	var pickhat=randi()%10
	var hat = get_node("AnimatedSprite/Hats")
	match pickhat:
		0:
			hat.animation="hat0"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		1:
			hat.animation="hat1"
			hat.set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
			hat.position.x=1
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
	if(!angry):
		if(get_node("AnimatedSprite").frame==0):
			get_node("AnimatedSprite/Hats").position.y=haty_up
		else:
			get_node("AnimatedSprite/Hats").position.y=haty_down
	else:
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
	if(angry):
		if(is_on_wall()):
			velocity.x=-velocity.x
		if(get_node("/root/Game/World").has_node("Player")):
			if(get_node("/root/Game/World/Player").global_position.y+2<global_position.y):
				jump()
		
		if($GunSight.is_colliding() and can_shoot):
			shoot()
	velocity.y = move_and_slide(velocity, Vector2.UP*gravity*delta).y


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
	get_node("DamagePlayer").queue_free()
	get_node("DetectPlayer").queue_free()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	blood.get_node("Particles2D").amount=int(25)
	get_parent().add_child(blood)
	queue_free()


func _on_DamagePlayer_body_entered(body: Node) -> void:
	if(!body.iframes_on):
		body.last_damage="Mole"
		if(body.health<2):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			if(!body.iframes_on):
				body.damage(1)
