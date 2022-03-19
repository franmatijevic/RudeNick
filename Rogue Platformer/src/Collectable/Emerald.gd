extends KinematicBody2D

export var value:int=10

var gravity:=250.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO
var jump:=150.0
var push:=80.0
var friction:=5.0

func _on_DetectPlayer_body_entered(body: Node) -> void:
	body.money+=value
	var color=preload("res://src/Other/MoneyParticle.tscn").instance()
	color.get_node("Money").process_material.color=Color(0.27,0.51,0.20)
	color.get_node("Money").emitting=true
	color.position=position
	get_parent().add_child(color)
	queue_free()

func _on_DetectWhip_area_entered(area: Area2D) -> void:
	if(velocity.x!=0.0):
		return
	if(!velocity.y<0.0):
		velocity.y-=jump
	if(area.global_position.x>global_position.x):
		velocity.x-=push
	else:
		velocity.x+=push

func _ready() -> void:
	wait()

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y
	
	if(velocity.x>speed.x):
		velocity.x=speed.x
	if(velocity.x<-speed.x):
		velocity.x=-speed.x
	
	if(velocity.x>0.0 and !velocity.y<0.0):
		velocity.x-=friction
	if(velocity.x<0.0 and !velocity.y<0.0):
		velocity.x+=friction

func wait()->void:
	var time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	$DetectPlayer.monitoring=true
