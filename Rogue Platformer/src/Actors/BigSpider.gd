extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=15

var jump_speed:=205.0

var big_range:=false
var small_range:=false


var last_damage="bigspider"

var normal_speed:=35.0
var fast_speed:=80.0

var is_attacking:=false

var is_in_air:=false

var count_cool_attack:int=0
var count_bite:int=0

func _ready() -> void:
	speed.x=normal_speed
	get_node("AnimatedSprite").animation="default"
	velocity.x = speed.x

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if(!$Floor.is_colliding() and !is_attacking and !is_in_air):
		is_in_air=true
		get_node("AnimatedSprite").animation="jump"
		get_node("AnimatedSprite").frame=0
	
	if($Floor.is_colliding() and is_in_air and !is_attacking):
		is_in_air=false
		get_node("AnimatedSprite").animation="default"
		velocity.x=abs(velocity.x)/velocity.x*normal_speed
	
	if(is_on_wall() and is_on_floor()):
		velocity.x*=-1
		$Player.cast_to.x*=-1
		get_node("AnimatedSprite").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite2").set_flip_h(!get_node("AnimatedSprite2").is_flipped_h())
		get_node("AnimatedSprite2").position.x*=-1
		get_node("Bite").position.x*=-1
	velocity.y = move_and_slide(velocity*can_move, Vector2.UP).y
	
	
	if($Player.is_colliding() and !is_attacking):
		is_attacking=true
		attack()

func spit()->void:
	var web=preload("res://src/Other/Spit.tscn").instance()
	web.position=position
	get_parent().add_child(web)

func jump()->void:
	if(!get_node("/root/Game/World").has_node("Player") or !is_on_floor()):
		return
	var player = get_node("/root/Game/World/Player")
	if((player.global_position.x>global_position.x and velocity.x<0.0) or (player.global_position.x<global_position.x and velocity.x>0.0)):
		velocity.x=-(velocity.x)
		$Player.cast_to.x*=-1
		get_node("AnimatedSprite").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite2").set_flip_h(!get_node("AnimatedSprite2").is_flipped_h())
		get_node("AnimatedSprite2").position.x*=-1
		get_node("Bite").position.x*=-1
	velocity.y-=jump_speed
	velocity.x=abs(velocity.x)/velocity.x*fast_speed

func attack()->void:
	if(randi()%10==0):
		spit()
		is_attacking=false
		velocity.x=abs(velocity.x)/velocity.x*normal_speed
		return
	if(!$Ground.is_colliding()):
		velocity.x=abs(velocity.x)/velocity.x*3
	get_node("AnimatedSprite").visible=false
	get_node("AnimatedSprite2").visible=true
	get_node("AnimatedSprite2").frame=0
	yield(get_tree().create_timer(0.5), "timeout")
	get_node("Bite").monitoring=true
	yield(get_tree().create_timer(0.1), "timeout")
	get_node("Bite").monitoring=false
	get_node("AnimatedSprite").visible=true
	get_node("AnimatedSprite2").visible=false
	velocity.x=abs(velocity.x)/velocity.x*normal_speed
	is_attacking=false

func cool_attack()->void:
	spit()
	yield(get_tree().create_timer(0.5), "timeout")
	jump()

func death()->void:
	#get_parent().get_node("TrollDeath").play()
	get_node("CollisionShape2D").free()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.position=position
	blood.position.y=blood.position.y-12
	blood.get_node("Particles2D").amount=50
	var meat=preload("res://src/Items/WhiteKey.tscn").instance()
	meat.position=blood.position
	get_parent().add_child(meat)
	get_parent().add_child(blood)
	queue_free()

func damage(value: int)->void:
	velocity.x=abs(velocity.x)/velocity.x*fast_speed
	if(health<value+1):
		death()
		return
	flash_damage()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.position=position
	blood.position.y=blood.position.y-10
	get_parent().add_child(blood)
	health=health-value
	if(randi()%6==0):
		cool_attack()

func flash_damage()->void:
	var time_in_seconds
	for i in range(5):
		if(i%2==0): modulate.a=0.5
		else: modulate.a=1
		time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")
	modulate.a=1

func destroy()->void:
	death()


func _on_Head_body_entered(body: Node) -> void:
	if(body.global_position.y<global_position.y):
		body.enemy_jump()


func _on_Whip_area_entered(area: Area2D) -> void:
	damage(1)

func _on_Damage_body_entered(body: Node) -> void:
	if(!body.iframes_on and body.global_position.y>global_position.y-6):
		body.last_damage=last_damage
		body.iframes()
		if(body.health==1):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		body.damage(1)


func _on_Bite_body_entered(body: Node) -> void:
	if(!body.iframes_on):
		body.last_damage=last_damage
		body.iframes()
		if(body.health<3):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		body.damage(2)

func _on_DetectPlayer_body_entered(body: Node) -> void:
	big_range=true
	if(randi()%3==0):
		cool_attack()
	if(!get_node("/root/Game/World").has_node("Player") or !is_on_floor()):
			return
	var player = get_node("/root/Game/World/Player")
	if((player.global_position.x>global_position.x and velocity.x<0.0) or (player.global_position.x<global_position.x and velocity.x>0.0)):
		velocity.x=-(velocity.x)
		$Player.cast_to.x*=-1
		get_node("AnimatedSprite").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite2").set_flip_h(!get_node("AnimatedSprite2").is_flipped_h())
		get_node("AnimatedSprite2").position.x*=-1
		get_node("Bite").position.x*=-1

func _on_DetectPlayer_body_exited(body: Node) -> void:
	big_range=false
	if(!get_node("/root/Game/World").has_node("Player") or !is_on_floor()):
		return
	var player = get_node("/root/Game/World/Player")
	if((player.global_position.x>global_position.x and velocity.x<0.0) or (player.global_position.x<global_position.x and velocity.x>0.0)):
		velocity.x=-(velocity.x)
		$Player.cast_to.x*=-1
		get_node("AnimatedSprite").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite2").set_flip_h(!get_node("AnimatedSprite2").is_flipped_h())
		get_node("AnimatedSprite2").position.x*=-1
		get_node("Bite").position.x*=-1


func _on_ClosePlayer_body_entered(body: Node) -> void:
	small_range=true
	if(!get_node("/root/Game/World").has_node("Player") or !is_on_floor()):
		return
	var player = get_node("/root/Game/World/Player")
	if((player.global_position.x>global_position.x and velocity.x<0.0) or (player.global_position.x<global_position.x and velocity.x>0.0)):
		velocity.x=-(velocity.x)
		$Player.cast_to.x*=-1
		get_node("AnimatedSprite").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite2").set_flip_h(!get_node("AnimatedSprite2").is_flipped_h())
		get_node("AnimatedSprite2").position.x*=-1
		get_node("Bite").position.x*=-1

func _on_ClosePlayer_body_exited(body: Node) -> void:
	small_range=false
	if(randi()%3==0):
		cool_attack()
