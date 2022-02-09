extends KinematicBody2D

export var value:int=1

var gravity:=50.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO
var jump:=50.0
var push:=150.0

func _on_DetectWhip_area_entered(area: Area2D) -> void:
	velocity.y=0.0
	velocity.y-=jump
	if(area.global_position.x>global_position.x):
		velocity.x-=push
	else:
		velocity.x+=push


func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y
	
	if(velocity.x<5.0 and velocity.x>-5.0):
		velocity.x=0.0
	if(velocity.x>0.0):
		velocity.x-=10
	if(velocity.x<0.0):
		velocity.x+=10



