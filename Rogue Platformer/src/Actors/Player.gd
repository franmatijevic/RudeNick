extends Actor

var climbing_speed: = 50.0
var stomp_impulse: = 100.0
var health

var walk_speed:=75.0
var run_speed:=120.0
var slowed_speed:=50.0
var normal_jump:=225.0
var slowed_jump:=150.0

var iframes_on:=false
var is_attacking: = false
var smjer: = false
var ledge_grab: = false
var climbing:=false
var is_running:=true
var spider_web:=false

var move_up:=false
var move_down:=false
var move_left:=false
var move_right:=false

var move_horizontal:=1

onready var animatedSprite = $AnimatedSprite

func _ready() -> void:
	speed.x=run_speed
	speed.y=225.0
	stomp_impulse=250.0
	health=40

func _on_webDetect_area_entered(area: Area2D) -> void:
	spider_web=true

func _on_webDetect_area_exited(area: Area2D) -> void:
	spider_web=false

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	if !is_on_floor():
		climbing=false
		using_gravity=1
		move_horizontal=1 
		velocity = calculate_stomp_velocity(velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	if(!iframes_on):
		health-=1
		iframes()
		treperenje()
		move_horizontal=0
		var time_in_seconds = 0.1
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		move_horizontal=1
	#queue_free()
	return

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("up")): move_up=true
	if(Input.is_action_just_released("up")): move_up=false
	if(Input.is_action_just_pressed("down")): move_down=true
	if(Input.is_action_just_released("down")): move_down=false
	if(Input.is_action_just_pressed("run")): is_running=false
	if(Input.is_action_just_released("run")): is_running=true
	
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
	
	if(health==0): queue_free()
	#print(health)
	
	if(!is_attacking and !ledge_grab):
		if(velocity.x>0): 
			smjer=false
			$LedgeY.position.x = 7
			$LedgeX.position.x = 6
		elif(velocity.x<0): 
			smjer=true
			$LedgeY.position.x = -7
			$LedgeX.position.x = -6
	get_node("AnimatedSprite").set_flip_h( smjer )
	if(Input.is_action_pressed("action") && is_attacking==false): action()
	
	if(velocity.x!=0 and is_attacking==false and climbing==false and !ledge_grab): animatedSprite.animation="walking"
	elif(!is_attacking and climbing==false and !ledge_grab): animatedSprite.animation="default"
	elif(climbing and velocity.y!=0 and !is_attacking and !ledge_grab): animatedSprite.animation="climbing"
	elif(!is_attacking and !ledge_grab): animatedSprite.animation="climbing_stop"
	elif(ledge_grab): animatedSprite.animation="hanging"
	
	if(Input.is_action_just_pressed("up") && $ladderCheck.is_colliding() and !is_attacking and !ledge_grab): ladder()

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and velocity.y < 0
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if(climbing):
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
	
	if($LedgeX.is_colliding() && !is_attacking && !climbing): hold_ledge()
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

func get_direction() -> Vector2:
	return Vector2(
		(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))*move_horizontal,
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func damage()->void:
	pass



func ladder()->void:
	climbing=true
	using_gravity=0
	move_horizontal=0
	velocity.y=-climbing_speed
	set_global_position(Vector2($ladderCheck.get_collider().get_global_position().x, get_global_position().y))
	

func hold_ledge()->void:
	if(!$LedgeY.is_colliding() and !is_on_floor()):
		if(velocity.y>0 and !move_down or velocity.y<0 and move_down):
			if(!ledge_grab): 
				if(!smjer): set_global_position(Vector2($LedgeX.get_collider().get_global_position().x-12, $LedgeX.get_collider().get_global_position().y))
				else: set_global_position(Vector2($LedgeX.get_collider().get_global_position().x+12, $LedgeX.get_collider().get_global_position().y))
			ledge_grab=true
			move_horizontal=0
			using_gravity=0
			velocity.y=0.0

func action()-> void:
	var k
	if(smjer==false): k=1
	else: k=-1
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
	time_in_seconds = 0.3
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("Area2D/whip_node").disabled=true
	get_node("Area2D/whip_node").position.x=0
	get_node("Area2D/whip_node").position.y=0
	
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
	var time_in_seconds = 1.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	#modulate.a=1
	iframes_on=false

func treperenje()->void:
	var time_in_seconds
	for i in range(10):
		if(i%2==0): modulate.a=0.2
		else: modulate.a=1
		time_in_seconds = 0.15
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		


