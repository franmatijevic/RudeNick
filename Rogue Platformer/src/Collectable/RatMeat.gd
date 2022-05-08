extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO

var animation:=false

var special:=false
var value:int=1

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y
	if(animation):
		get_node("RatMeat").position.y-=delta*90
		get_node("RatMeat").scale.x+=delta*0.6
		get_node("RatMeat").scale.y+=delta*0.6
		get_node("RatMeat").modulate.a-=delta*1.5
		if(get_node("RatMeat").modulate.a<0):
			queue_free()

func _ready() -> void:
	if(special):
		value=2
		get_node("RatMeat").queue_free()
		get_node("RatMeatErika").name="RatMeat"
	else:
		get_node("RatMeatErika").queue_free()
	wait()

func wait()->void:
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("DetectPlayer").monitoring=true


func _on_DetectPlayer_body_entered(body: Node) -> void:
	if(!animation):
		body.health+=value
		play_animation()

func play_animation()->void:
	gravity=0.0
	velocity.y=0.0
	get_node("DetectPlayer").monitoring=false
	animation=true
