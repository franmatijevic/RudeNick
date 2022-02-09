extends KinematicBody2D

export var value:int=1

var gravity:=230.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO
var jump:=150.0
var push:=80.0
var friction:=5.0

func _on_DetectPlayer_body_entered(body: Node) -> void:
	body.money+=value
	queue_free()

func _on_Whip_area_entered(area: Area2D) -> void:
	if(velocity.x!=0.0):
		return
	
	if(!velocity.y<0.0):
		velocity.y-=jump
	if(area.global_position.x>global_position.x):
		velocity.x-=push
	else:
		velocity.x+=push

func _ready() -> void:
	randomize()
	var type=randi()%5
	match type:
		0:
			$Gold2.queue_free()
			$Gold3.queue_free()
			$Gold4.queue_free()
			$Gold5.queue_free()
		1:
			$Gold1.queue_free()
			$Gold3.queue_free()
			$Gold4.queue_free()
			$Gold5.queue_free()
		2:
			$Gold1.queue_free()
			$Gold2.queue_free()
			$Gold5.queue_free()
			$Gold4.queue_free()
		3:
			$Gold1.queue_free()
			$Gold2.queue_free()
			$Gold3.queue_free()
			$Gold5.queue_free()
		4:
			$Gold1.queue_free()
			$Gold2.queue_free()
			$Gold3.queue_free()
			$Gold4.queue_free()

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


