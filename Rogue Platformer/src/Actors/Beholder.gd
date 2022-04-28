extends KinematicBody2D

export var speed: = Vector2(5.0, 1.0)
export var gravity: = 0.0
var using_gravity: = 1

var velocity: = Vector2.ZERO

var health:=20

func _ready() -> void:
	get_node("AnimatedSprite").animation="default"
	get_node("DestroyBlocks").monitoring=true
	gravity=0.0
	velocity.x=25.0

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
	
	velocity.y = move_and_slide(velocity).y
	
	if($Wall.is_colliding()):
		$Wall.cast_to.x*=-1
		velocity.x*=-1
	
	
	if(Input.is_action_just_pressed("ui_accept")):
		shoot_small_laser()

func shoot_small_laser()->void:
	var laser = preload("res://src/Other/LaserSmall.tscn").instance()
	laser.position=position
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
	damage(1)
