extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=15

var music:=false

var last_damage="serpant"

var normal_speed:=35.0
var fast_speed:=75.0

var is_attacking:=false

func _ready() -> void:
	speed.x=normal_speed
	get_node("AnimatedSprite").animation="default"
	velocity.x = speed.x

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if(get_node("AnimatedSprite2").frame==2):
		get_node("DamageArea").monitoring=true
	else:
		get_node("DamageArea").monitoring=false
	
	if(is_on_wall() and is_on_floor()):
		velocity.x=abs(velocity.x) / (-velocity.x) * normal_speed
		$Player.cast_to.x*=-1
		get_node("AnimatedSprite").set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
		get_node("AnimatedSprite2").set_flip_h(!get_node("AnimatedSprite2").is_flipped_h())
		get_node("AnimatedSprite2").position.x*=-1
		get_node("Prepare").position.x*=-1
		get_node("DamageArea").position.x*=-1
	velocity.y = move_and_slide(velocity*can_move, Vector2.UP).y
	
	if($Player.is_colliding()):
		velocity.x=abs(velocity.x) / velocity.x * fast_speed
		music()

func death()->void:
	#get_parent().get_node("TrollDeath").play()
	get_node("CollisionShape2D").free()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.position=position
	blood.position.y=blood.position.y-12
	blood.get_node("Particles2D").amount=50
	var meat=preload("res://src/Items/RedKey.tscn").instance()
	meat.position=blood.position
	get_parent().add_child(blood)
	get_parent().add_child(meat)
	queue_free()

func damage(value: int)->void:
	if(health<value+1):
		death()
		return
	flash_damage()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.position=position
	blood.position.y=blood.position.y-10
	get_parent().add_child(blood)
	health=health-value

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

func attack()->void:
	can_move=0
	yield(get_tree().create_timer(0.3), "timeout")
	get_node("AnimatedSprite2").frame=0
	get_node("AnimatedSprite2").visible=true
	get_node("AnimatedSprite").visible=false
	yield(get_tree().create_timer(0.6), "timeout")
	#while(get_node("AnimatedSprite2").frame!=2):
	#	pass
	get_node("AnimatedSprite").visible=true
	get_node("AnimatedSprite2").visible=false
	can_move=1
	is_attacking=false

func _on_Head_body_entered(body: Node) -> void:
	body.enemy_jump()
	velocity.x=abs(velocity.x) / velocity.x * fast_speed


func _on_Whip_area_entered(area: Area2D) -> void:
	damage(1)
	velocity.x=abs(velocity.x) / velocity.x * fast_speed
	music()
	if(randi()%2==0):
		return
	var ball1=preload("res://src/Other/SnakeBall.tscn").instance()
	var ball2=preload("res://src/Other/SnakeBall.tscn").instance()
	ball1.position=position
	ball2.position=position
	ball1.knock=true
	get_parent().add_child(ball1)
	get_parent().add_child(ball2)


func _on_Prepare_body_entered(body: Node) -> void:
	if(!is_attacking):
		is_attacking=true
		attack()

func music()->void:
	get_node("/root/Game/World").raging_music()


func _on_DamageArea_body_entered(body: Node) -> void:
	if(body.name=="Player" and !body.iframes_on):
		body.last_damage=last_damage
		body.iframes()
		if(body.health==1):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		body.poison()
		body.damage(1)


func _on_BodyDamage_body_entered(body: Node) -> void:
	if(!body.iframes_on):
		body.last_damage=last_damage
		body.iframes()
		if(body.health==1):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		body.damage(1)
