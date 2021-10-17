extends Actor

export var stomp_impulse: = 100.0
var is_attacking: = false
var direction: = false

onready var animatedSprite = $AnimatedSprite

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	queue_free()
	return

func _ready() -> void:
	speed.x=100.0
	speed.y=225.0
	stomp_impulse=250.0

func _process(delta: float) -> void:
	if(is_attacking==false):
		if(velocity.x>0): direction=false
		elif(velocity.x<0): direction=true
	get_node("AnimatedSprite").set_flip_h( direction )
	if(Input.is_action_pressed("action") && is_attacking==false): action()
	
	if(velocity.x!=0 and is_attacking==false): animatedSprite.animation="walking"
	elif(!is_attacking): animatedSprite.animation="default"
	


func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and velocity.y < 0
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	velocity = move_and_slide(velocity, Vector2.UP)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func action()-> void:
	var k
	if(direction==false): k=1
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
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: = linear_velocity 
	out.y = -impulse
	return out





