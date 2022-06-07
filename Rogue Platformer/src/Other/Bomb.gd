extends KinematicBody2D

var boom
var in_hands:=true

var time:float=0.0

var velocity=Vector2.ZERO
var gravity:float=200.0

var up:=false
var down:=false

var summoned:=true

func _ready() -> void:
	#get_node("/root/Game").bomb_in_hands=true
	get_node("/root/Game/World/Player").bomb_in_hands=true
	get_node("Sound").play()
	get_node("AnimatedSprite").frame=0
	boom=preload("res://src/Other/Expolsion.tscn").instance()
	#wait()

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("up")):
		up=true
	if(Input.is_action_just_released("up")):
		up=false
	if(Input.is_action_just_pressed("down")):
		down=true
	if(Input.is_action_just_released("down")):
		down=false
	
	time+=delta
	if(time>3):
		wait()
	
	#if(Input.is_action_just_pressed("bomb") and get_node("/root/Game/World").has_node("Player") and in_hands and time>0.5):
	if(Input.is_action_just_pressed("bomb") and in_hands):
		if(1==1):
			var direction
			if(get_node("/root/Game/World/Player/AnimatedSprite").is_flipped_h()):
				direction=-1
			else:
				direction=1
			if(in_hands):
				get_node("/root/Game/World/Player").bomb_in_hands=false
				#get_node("/root/Game").bomb_in_hands=false
				if((!down and !up)):
					velocity.x=100.0*direction
					velocity.y=-100.0
				elif(up):
					velocity.x=60.0*direction
					velocity.y=-180.0
			in_hands=false
			#get_node("/root/Game/World/Player").bomb_in_hands=false
	if(in_hands):
		follow_player()
	else:
		#get_node("AnimatedSprite").rotation_degrees+=delta*60
		velocity.y+=gravity*delta
		if(velocity.y>500):
			velocity.y=500
		velocity = move_and_slide(velocity)

func follow_player()->void:
	if(get_parent().has_node("Player")):
		position.x=get_parent().get_node("Player").position.x
		position.y=get_parent().get_node("Player").position.y

func wait()->void:
	#var time_in_seconds = 3
	#yield(get_tree().create_timer(time_in_seconds), "timeout")
	boom.position.x=position.x
	boom.position.y=position.y+3
	#boom.get_node("KillBeings").scale.y=1.1
	get_parent().add_child(boom)
	queue_free()

func timer(lenght:float)->void:
	var time=0.0
	while(time<lenght):
		time+=get_physics_process_delta_time()


func _on_Wall_body_entered(body):
	if(!in_hands):
		if(velocity.x!=0):
			velocity.x/=-3


func _on_Friction_body_entered(body):
	if(velocity.x!=0):
		velocity.x/=3
	if(abs(velocity.x)<5.0):
		velocity.x=0.0
		return 
	velocity.y/=-5
	velocity.y-=45


func _on_Whip_area_entered(area: Area2D) -> void:
	if(!in_hands):
		velocity.y-=50
		if(area.get_parent().global_position.x<global_position.x):
			velocity.x+=40
		else:
			velocity.x-=40
