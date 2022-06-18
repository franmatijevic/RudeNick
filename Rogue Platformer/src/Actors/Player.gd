extends Actor

var climbing_speed: = 50.0
var stomp_impulse: = 100.0
var health :int= 10
var money:int=0
var rope:int=4
var bomb:int=4
var shotgun:int=0
var goggles:=false

var walk_speed:=75.0
var run_speed:=105.0
var slowed_speed:=30.0
var normal_jump:=225.0
var slowed_jump:=150.0

var poisoned:=false
var iframes_on:=false
var is_attacking: = false
var smjer: = false
var ledge_grab: = false
var climbing:=false
var is_running:=true
var spider_web:=false
var exits_level:=false
var collides_w_enemy:=false
var bomb_in_hands:=false

var burned_death:=false
var club_death:=false
var spike_death:=false

var look_down:=false

var near_exit:=false
var stop:=1

var dungeon_gate:=false

var move_up:=false
var move_down:=false
var move_left:=false
var move_right:=false

var move_horizontal:=1

onready var animatedSprite = $AnimatedSprite
var spike_boots:=false

var last_damage:String=" "
var if_stunned:bool=false
var stunned_mod:int=1
var side_stunned:bool=false
var stunned_up:bool=false
var stun_time:float=3.0
var knock_h:float=0.0
var knock_v:float=0.0
var friction:float=20.0

func _ready() -> void:
	if(poisoned):
		poison()
	speed.x=run_speed
	speed.y=225.0
	stomp_impulse=250.0

func _on_exitDetect_body_entered(body: Node) -> void:
	near_exit=true
func _on_exitDetect_body_exited(body: Node) -> void:
	near_exit=false

func _on_webDetect_area_entered(area: Area2D) -> void:
	spider_web=true
func _on_webDetect_area_exited(area: Area2D) -> void:
	spider_web=false

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	area.get_parent().death()
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=area.global_position
	area.get_parent().add_child(blood) 
	enemy_jump()

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	if(!iframes_on):
		last_damage=body.last_damage
		var blood=preload("res://src/Other/Blood.tscn").instance()
		blood.global_position=global_position
		get_parent().add_child(blood)
		if(health<2):
			var knock:=true
			if(body.global_position.x>global_position.x):
				knock=false
			death(knock)
		damage(1)

func _on_Boss_area_entered(area: Area2D) -> void:
	#if(area.get_parent().name=="Troll"):
	#	return
	var damage=2
	if(get_node("/root/Game").easy_mode):
		damage=1
	
	if(!iframes_on):
		last_damage=area.get_parent().last_damage
		if(health<damage+1):
			var knock:=true
			if(area.get_parent().global_position.x>global_position.x):
				knock=false
			death(knock)
		damage(damage)

var high:=999.0
var sky:=false

func summon_bomb()->void:
	bomb=bomb-1
	var bomba=preload("res://src/Other/Bomb.tscn").instance()
	bomba.position=position
	get_parent().add_child(bomba)

func _process(delta: float) -> void:
	if(!if_stunned and velocity.x!=0 and is_on_floor()):
		if(!get_node("Walk").is_playing()):
			get_node("Walk").play()
	else:
		get_node("Walk").stop()
	
	if(!is_on_floor() and !sky):
		high=global_position.y
		sky=true
	if(velocity.y<0.0 and !sky):
		high=global_position.y
		sky=true
	if(sky and is_on_floor()):
		sky=false
		if(global_position.y-high>16*7):
			last_damage="fall"
			if(health==1):
				death(true)
			damage(1)
			stunned()
	var ui = get_parent().get_node("Kanvas").get_node("UI")
	ui.get_node("health").text=str(health)
	ui.get_node("money").text=str(money*100)
	ui.get_node("Ropes").text=str(rope)
	ui.get_node("bomb_n").text=str(bomb)
	
	get_node("Shotgun").set_flip_h($AnimatedSprite.is_flipped_h())
	if(shotgun>0 and !if_stunned):
		get_node("Shotgun").visible=true
	else:
		get_node("Shotgun").visible=false
	
	if(Input.is_action_just_pressed("up")): move_up=true
	if(Input.is_action_just_released("up")): move_up=false
	if(Input.is_action_just_pressed("down")): move_down=true
	if(Input.is_action_just_released("down")): move_down=false
	if(Input.is_action_just_pressed("run")): is_running=false
	if(Input.is_action_just_released("run")): is_running=true
	
	if(Input.is_action_just_pressed("rope") and rope>0 and !if_stunned):
		rope=rope-1
		var rope=preload("res://src/Other/RopeTop.tscn").instance()
		rope.global_position=global_position
		var newx = int(round(global_position.x))/16
		newx = newx * 16 + 8
		rope.global_position.x=newx
		if(look_down and !ledge_grab):
			rope.look_down=true
			if(smjer):
				rope.global_position.x=rope.global_position.x-16
			else:
				rope.global_position.x=rope.global_position.x+16
		get_parent().add_child(rope)
	
	#if(Input.is_action_just_pressed("bomb") and !if_stunned):
	#	if(!get_node("/root/Game").bomb_in_hands and bomb>0):
		#	summon_bomb()
		
		#if(bomb_in_hands):
		#	pass
		#elif(!bomb_in_hands and bomb>0):
			#bomb_in_hands=true
		#	bomb=bomb-1
		#	var bomba=preload("res://src/Other/Bomb.tscn").instance()
		#	bomba.position=position
		#	get_parent().add_child(bomba)
	
	if(spider_web): 
		if(Input.is_action_just_pressed("jump")): 
			velocity.y=-speed.y
		speed.x=slowed_speed
		speed.y=slowed_jump
	elif(is_running):
		speed.x=run_speed
		speed.y=normal_jump
	else:
		speed.x=walk_speed
		speed.y=normal_jump
	
	
	if(!is_attacking and !ledge_grab):
		if(velocity.x>0): 
			smjer=false
			$LedgeY.position.x = 7
			$LedgeX.position.x = 6
		elif(velocity.x<0): 
			smjer=true
			$LedgeY.position.x = -7
			$LedgeX.position.x = -6
	
	
	if(Input.is_action_just_pressed("move_left") and !ledge_grab and !is_attacking and move_horizontal==1 and !if_stunned):
		smjer=1
		$LedgeX.global_position.x=position.x-6
		$LedgeY.global_position.x=position.x-7
	if(Input.is_action_just_pressed("move_right") and !ledge_grab and !is_attacking and move_horizontal==1 and !if_stunned):
		smjer=0
		$LedgeX.global_position.x=position.x+12
		$LedgeY.global_position.x=position.x+7
	get_node("AnimatedSprite").set_flip_h( smjer )
	if(Input.is_action_just_pressed("action") && is_attacking==false and !exits_level and !ledge_grab and !if_stunned): action()
	
	if(health>0):
		if(!if_stunned):
			if(velocity.x!=0 and is_attacking==false and climbing==false and !ledge_grab): animatedSprite.animation="walking"
			elif(!is_attacking and climbing==false and !ledge_grab and !exits_level): animatedSprite.animation="default"
			elif(climbing and velocity.y!=0 and !is_attacking and !ledge_grab): animatedSprite.animation="climbing"
			elif(!is_attacking and !ledge_grab): animatedSprite.animation="climbing_stop"
			elif(ledge_grab): animatedSprite.animation="hanging"
		else:
			animatedSprite.animation="stunned"
	
	if(Input.is_action_just_pressed("up") && $ladderCheck.is_colliding() and !is_attacking and !ledge_grab and !if_stunned): ladder()

func _physics_process(delta: float) -> void:
	if(if_stunned):
		var vel=Vector2.ZERO
		var k:=false
		if(!k):
			vel.x+=knock_h
			velocity.y-=knock_v
			k=true
		#vel.y+=gravity*delta#*100
		move_and_slide(vel)
		if(vel.x>0.0 and !vel.y<0.0):
			vel.x-=friction
		if(vel.x<0.0 and !vel.y<0.0):
			vel.x+=friction
		if(is_on_wall()):
			vel.x=0.0
			vel.y=vel.y/3
		if(is_on_ceiling() and vel.y<0.0):
			pass
			#vel.y=-vel.y
		if(is_on_floor()):
			vel.x=0.0
			vel.y=0.0
			velocity.x=0.0
	var is_jump_interrupted: = Input.is_action_just_released("jump") and velocity.y < 0
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	velocity = move_and_slide(velocity*stop, Vector2.UP*stop)
	
	if($BuyIt.is_colliding()):
		$BuyIt.get_collider().e()
		if(Input.is_action_just_pressed("buy")):
			$BuyIt.get_collider().buy()
	
	
	
	if(velocity.x==0 and move_up and !move_left and !move_right and (is_on_floor() or ledge_grab)):
		get_node("Camera2D").position.y=-55
		look_down=false
	elif(velocity.x==0 and move_down and !move_left and !move_right and (is_on_floor() or ledge_grab) ):
		get_node("Camera2D").position.y=45
		look_down=true
	else:
		get_node("Camera2D").position.y=-10
		look_down=false
	
	if(climbing):
		sky=false
		if(Input.is_action_just_pressed("move_left") and !is_attacking): smjer=true
		if(Input.is_action_just_pressed("move_right") and !is_attacking): smjer=false
		if(!move_up and !move_down): velocity.y=0
		if(move_down==true and $ladderCheck.is_colliding()): velocity.y=+climbing_speed
		if(move_up==true and $ladderCheck2.is_colliding()): velocity.y=-climbing_speed
		if(!$ladderCheck.is_colliding() and velocity.y<0): velocity.y=0
		if(!$ladderCheck2.is_colliding() and velocity.y>0): velocity.y=0
		if(!$ladderCheck.is_colliding() and $ladderCheck2.is_colliding() and move_down): velocity.y=climbing_speed
		if(Input.is_action_just_pressed("jump")): 
			climbing=false
			using_gravity=1
			move_horizontal=1 
			if(!move_down):
				velocity.y-=speed.y
		if(is_on_floor()): 
			climbing=false
			using_gravity=1
			move_horizontal=1
	
	if($LedgeX.is_colliding() && !is_attacking && !climbing && !is_running): hold_ledge()
	if(ledge_grab):
		if(Input.is_action_just_pressed("jump")):
			if(!move_down): velocity.y-=speed.y
			move_horizontal=1
			using_gravity=1
			ledge_grab=false
		if(!$LedgeX.is_colliding() or $LedgeY.is_colliding() or is_on_floor()):
			ledge_grab=0
			move_horizontal=1
			using_gravity=1
	
	if(near_exit and Input.is_action_just_pressed("buy") and !if_stunned):
		
		exitlevel()

func get_direction() -> Vector2:
	return Vector2(
		(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))*move_horizontal*stunned_mod,
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() and !exits_level and move_horizontal==1 and !if_stunned else 1.0
	)

func damage(value:int)->void:
	match randi()%5:
		0:
			get_node("Dam1").play()
		1:
			get_node("Dam2").play()
		2:
			get_node("Dam3").play()
		3:
			get_node("Dam4").play()
		4:
			get_node("Dam5").play()
	
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	get_parent().add_child(blood)
	velocity.x=0.0
	ledge_grab=false
	health-=value
	ledge_grab=false
	using_gravity=1
	iframes()
	treperenje()
	if(last_damage=="BlackSnake"):
		poison()
		get_node("/root/Game/AttackSnake").play()
	elif(last_damage=="snake"):
		get_node("/root/Game/AttackSnake").play()
	move_horizontal=0
	if(velocity.y>0.0):
		velocity.y=0
	var time_in_seconds = 0.4
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	move_horizontal=1

func stunned()->void:
	if_stunned=true
	stunned_mod=0
	ledge_grab=false
	climbing=false
	sky=false
	climbing=false
	using_gravity=1
	var time_in_seconds = stun_time
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	if_stunned=false
	stunned_mod=1
	stunned_up=false
	knock_h=0
	knock_v=0

func drop()->void:
	climbing=false
	using_gravity=1
	move_horizontal=1

func poison()->void:
	if(get_parent().poison_time==0.0):
		get_parent().poison_time=int(get_parent().current_time)
	poisoned=true
	get_node("AnimatedSprite").modulate.r=0.27
	get_node("AnimatedSprite").modulate.g=0.51
	get_node("AnimatedSprite").modulate.b=0.20
	get_node("/root/Game/World/Kanvas/UI/Poison2").visible=true
	#get_parent().get_node("Kanvas/UI/Poison").visible=true

func cure()->void:
	poisoned=false
	get_node("AnimatedSprite").modulate.r=1
	get_node("AnimatedSprite").modulate.g=1
	get_node("AnimatedSprite").modulate.b=1
	get_node("/root/Game/World/Kanvas/UI/Poison2").visible=false

func ladder()->void:
	climbing=true
	using_gravity=0
	move_horizontal=0
	velocity.y=-climbing_speed
	set_global_position(Vector2($ladderCheck.get_collider().get_global_position().x, get_global_position().y))
	

func hold_ledge()->void:
	if(!$LedgeY.is_colliding() and !is_on_floor()):
		if(velocity.y>0 and !move_down or velocity.y<0 and move_down):
			sky=false
			if(!ledge_grab): 
				if(!smjer): set_global_position(Vector2($LedgeX.get_collider().get_global_position().x-12, $LedgeX.get_collider().get_global_position().y))
				else: set_global_position(Vector2($LedgeX.get_collider().get_global_position().x+12, $LedgeX.get_collider().get_global_position().y))
			ledge_grab=true
			move_horizontal=0
			using_gravity=0
			velocity.y=0.0

func shotgun_effect()->void:
	move_horizontal=0
	if(velocity.y>0.0):
		velocity.y=0
	var time_in_seconds = 0.4
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	move_horizontal=1

func action()-> void:
	var k
	if(smjer==false): k=1
	else: k=-1
	if(shotgun>0):
		if(shotgun==1):
			get_parent().get_node("Kanvas/UI").print_something("My shotgun broke.")
		#velocity.x+=-k*100
		get_node("Shoot").play()
		var bullet=preload("res://src/Other/Bullet.tscn").instance()
		var bullet2=preload("res://src/Other/Bullet.tscn").instance()
		var bullet3=preload("res://src/Other/Bullet.tscn").instance()
		
		bullet.position=position
		bullet2.position=position
		bullet3.position=position
		
		bullet2.position.y+=3
		bullet3.position.y-=3
		
		bullet.player=true
		bullet2.player=true
		bullet3.player=true
		
		bullet.speed*=k
		var add=randi()%3
		bullet2.speed=bullet2.speed-add*50
		bullet2.speed*=k
		add=randi()%3
		bullet3.speed=bullet3.speed-add*50
		bullet3.speed*=k
		
		get_parent().add_child(bullet)
		get_parent().add_child(bullet2)
		get_parent().add_child(bullet3)
		shotgun=shotgun-1
		#shotgun_effect()
	else:
		get_node("Whip").play()
		is_attacking=true
		animatedSprite.animation="whiping"
		get_node("Area2D/whip_node").disabled=false
		#backwhiping
		get_node("Area2D/whip_node").position.x=-5*k
		get_node("Area2D/whip_node").position.y=-6
		var time_in_seconds = 0.2
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		#frontwhiping
		get_node("Area2D/whip_node").position.y=0
		get_node("Area2D/whip_node").position.x=9.3*k
		time_in_seconds = 0.2
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		get_node("Area2D/whip_node").disabled=true
		get_node("Area2D/whip_node").position.x=0
		get_node("Area2D/whip_node").position.y=0
	
	#if(!smjer): set_global_position(Vector2($LedgeX.get_collider().get_global_position().x-12, $LedgeX.get_collider().get_global_position().y))
	#else: set_global_position(Vector2($LedgeX.get_collider().get_global_position().x+12, $LedgeX.get_collider().get_global_position().y))
	is_attacking=false
	animatedSprite.animation="default"

func calculate_move_velocity(
	linear_velocity: Vector2,
	direction: Vector2,
	speed: Vector2,
	is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time() * using_gravity
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity 
	out.y = -impulse
	return out

func iframes()->void:
	iframes_on=true
	var time_in_seconds = 3
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	#modulate.a=1
	iframes_on=false

func treperenje()->void:
	var time_in_seconds
	for i in range(20):
		if(i%2==0): modulate.a=0.2
		else: modulate.a=1
		time_in_seconds = 0.15
		yield(get_tree().create_timer(time_in_seconds), "timeout")

func exitlevel()->void:
	if(get_node("/root/Game/World").has_node("Music1")):
		get_node("/root/Game/World/Music1").stop()
	if(get_node("/root/Game/World").has_node("Music2")):
		get_node("/root/Game/World/Music2").stop()
	if(get_node("/root/Game/World").has_node("Music3")):
		get_node("/root/Game/World/Music3").stop()
	if(get_node("/root/Game/World").has_node("Rage")):
		get_node("/root/Game/World/Rage").stop()
	
	if(get_node("/root/Game/World").temple):
		get_parent().get_node("exitPiece/exit").get_node("DungeonDoorsOpen").visible=true
		get_parent().get_node("exitPiece/exit").get_node("DungeonDoors").visible=false
	iframes_on=true
	get_parent().get_parent().player_health=health
	get_parent().get_parent().player_money=money
	get_parent().get_parent().player_rope=rope
	get_parent().get_parent().player_bomb=bomb
	get_parent().get_parent().shotgun=shotgun
	get_parent().get_parent().poisoned=poisoned
	get_parent().get_parent().goggles=goggles
	get_parent().get_parent().current_time=get_parent().current_time
	get_parent().get_parent().total_time+=get_parent().current_time
	stop=0
	get_node("Shotgun").visible=false
	get_node("Shotgun").position.x=-200
	var pos
	if(!dungeon_gate):
		pos=get_parent().get_node("exitPiece").get_node("exit").global_position
	else:
		pos=get_parent().get_node("DungeonGate").get_node("BossGate").global_position
	pos.y=pos.y+8
	position=pos
	exits_level=true
	climbing=true
	move_horizontal=0
	darker_effect()
	var transition = preload("res://src/Other/TransitionEffect.tscn").instance()
	transition.choice=true
	get_parent().add_child(transition)
	
	get_node("CollisionShape2D").disabled=true
	get_node("EnemyDetector").monitoring=false
	var time_in_seconds = 0.6
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_parent().get_parent().set_health()
	
	get_tree().get_root().get_node("Game").new_complete()

func darker_effect()->void:
	var time_in_seconds
	for i in range(60):
		i=i+2
		$AnimatedSprite.modulate = Color(1.0/i, 1.0/i, 1.0/i)
		time_in_seconds = 0.05
		yield(get_tree().create_timer(time_in_seconds), "timeout")

func killed_by()->void:
	var killed=get_node("/root/Game/World/Kanvas/UI/Killed")
	
	var time=get_parent().get_parent().total_time
	var minutes=floor(time/60.0)
	var seconds=int(time)%60
	
	get_node("/root/Game/World/Kanvas/UI/DialogBox").visible=false
	get_node("/root/Game/World/Kanvas/UI/DialogText").visible=false
	
	get_node("/root/Game/World/Kanvas/UI/Time_whole").text="Total time: \n"
	get_node("/root/Game/World/Kanvas/UI/LevelDead").text="Level: " + str(get_parent().level)
	if(seconds>9):
		get_node("/root/Game/World/Kanvas/UI/Time_whole").text=str(minutes)+":"+str(seconds)
	else:
		get_node("/root/Game/World/Kanvas/UI/Time_whole").text=str(minutes)+":0"+str(seconds)
	
	get_node("/root/Game/World/Kanvas/UI/Time_whole").text
	
	var portret=get_node("/root/Game/World/Kanvas/UI/Portrait")
	
	if(last_damage=="snake"):
		portret.texture=load("res://Assets/SnakeWalking/snake.png")
		killed.text="I was \nbitten by \na snake"
	elif(last_damage=="bat"):
		portret.texture=load("res://Assets/Bat/flying_bat1.png")
		killed.text="I was killed by a bat"
	elif(last_damage=="lava"):
		portret.texture=load("res://Assets/TempleBlocks/lava_top.png")
		killed.text="I was burned in lava"
	elif(last_damage=="Spikes"):
		portret.texture=load("res://Assets/Enviroment/spike_blood_1.png")
		killed.text="I got pierced in spikes"
	elif(last_damage=="explosion"):
		portret.texture=load("res://Assets/Bomb/bomba.png")
		killed.text="I got blown up"
	elif(last_damage=="arrow"):
		portret.texture=load("res://Assets/ArrowTrap/arrow.png")
		killed.text="I got shot by an arrow trap"
	elif(last_damage=="spider"):
		portret.texture=load("res://Assets/Spider/spider_small.png")
		killed.text="I was jumped on by a spider"
	elif(last_damage=="Mole"):
		portret.texture=load("res://Assets/Mole/mole.png")
		killed.text="The Mole got its revenge"
	elif(last_damage=="fall"):
		portret.texture=load("res://Assets/Player/player_dead.png")
		killed.text="The fall was a bit too long"
	elif(last_damage=="beholder"):
		portret.texture=load("res://Assets/GameOver/beholder_portrait.png")
		killed.text="I was no match for a beholder..."
	elif(last_damage=="bigspider"):
		killed.text="Giant spider ate me"
		portret.texture=load("res://Assets/GameOver/spider_big_portrait.png")
	elif(last_damage=="Troll"):
		killed.text="I got beaten up by a troll"
		portret.texture=load("res://Assets/GameOver/troll_portrait.png")
	elif(last_damage=="serpant"):
		killed.text="I was bitten by a serpant"
		portret.texture=load("res://Assets/GameOver/serpant_portrait.png")
	elif(last_damage=="BlackSnake"):
		killed.text="Poisonus snake was too dangerous"
		portret.texture=load("res://Assets/SnakeWalking/snake_dangerous.png")
	elif(last_damage=="Poison"):
		killed.text="Deadly poison was my end"
		portret.texture=load("res://Assets/Serpant/poison_icon.png")
	elif(last_damage=="rat"):
		killed.text="I was killed by a rat"
		portret.texture=load("res://Assets/Rat/rat_walk1.png")
	else:
		portret.texture=load("res://Assets/Player/player_dead.png")
		killed.text="I died"



func death(direciton: bool)->void:
	if(get_node("/root/Game").go_to_boss==true):
		if(get_node("/root/Game/World/Beholder").dead==true):
			return
		else:
			get_node("/root/Game/World/Beholder").health=80
	
	get_node("/root/Game/World/Kanvas/UI/HPbeholder").visible=false
	get_node("/root/Game/World/Kanvas/UI/BossHealthBar").visible=false
	get_node("/root/Game/World/Kanvas/UI/Boss_name").visible=false
	
	if(get_node("/root/Game/World").has_node("Music1")):
		get_node("/root/Game/World/Music1").stop()
	if(get_node("/root/Game/World").has_node("Music2")):
		get_node("/root/Game/World/Music2").stop()
	if(get_node("/root/Game/World").has_node("Music3")):
		get_node("/root/Game/World/Music3").stop()
	if(get_node("/root/Game/World").has_node("Rage")):
		get_node("/root/Game/World/Rage").stop()
	
	get_node("/root/Game/World/Kanvas/UI/GameOverSound").play()
	
	get_node("/root/Game/World/Kanvas/UI/MoleIcon").visible=false
	get_node("/root/Game/World/Kanvas/UI/Poison2").visible=false
	
	get_node("/root/Game/World/Kanvas/UI/Darkness").visible=false
	get_node("/root/Game/World/Kanvas/UI/DarknessBoss").visible=false
	
	get_parent().get_parent().total_time+=get_parent().current_time
	killed_by()
	get_parent().get_node("Kanvas/UI").dead=true
	#game_over()
	get_parent().get_parent().can_pause=false
	print(last_damage)
	var corpse=preload("res://src/Actors/DeadPlayer.tscn").instance()
	#get_parent().get_node("Kanvas/UI").draw=false
	get_parent().get_node("Kanvas/UI/Heart1").queue_free()
	get_parent().get_node("Kanvas/UI/health").queue_free()
	get_parent().get_node("Kanvas/UI/HeartBroken").visible=true
	if(last_damage=="fall" or last_damage=="lava"):
		corpse.push=0.0
	
	if(last_damage=="lava"):
		corpse.push_v=25.0
		corpse.gravity/=8
	
	if(club_death):
		corpse.push=300.0
		corpse.push_v=100.0
		corpse.friction=2.0
	corpse.spikes=spike_death
	corpse.get_node("Camera2D").limit_right=get_node("Camera2D").limit_right
	corpse.get_node("Camera2D").limit_bottom=get_node("Camera2D").limit_bottom
	corpse.get_node("Camera2D").limit_top=get_node("Camera2D").limit_top
	corpse.get_node("Camera2D").limit_left=get_node("Camera2D").limit_left
	
	if(burned_death):
		corpse.get_node("Sprite").modulate.r=0.26
		corpse.get_node("Sprite").modulate.g=0.19
		corpse.get_node("Sprite").modulate.b=0.19
		corpse.push=200.0
		corpse.friction=2.0
	if(direciton):
		corpse.knock=false
	else:
		corpse.knock=true
	corpse.position=position
	get_parent().add_child(corpse)
	queue_free()



func enemy_jump()->void:
	sky=false
	climbing=false
	using_gravity=1
	move_horizontal=1
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)

