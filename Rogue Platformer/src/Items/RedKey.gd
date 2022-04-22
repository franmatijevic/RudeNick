extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO

var animation:=false

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y
	if(animation):
		get_node("KeyRed").position.y-=35.0*delta
		get_node("KeyRed").modulate.a-=0.8*delta
		get_node("KeyRed").scale.x+=delta*0.4
		get_node("KeyRed").scale.y+=delta*0.4
		if(get_node("KeyRed").modulate.a<0):
			queue_free()


func _on_Player_body_entered(body: Node) -> void:
	z_index=10
	get_node("Player").monitoring=false
	get_node("/root/Game").red_key=true
	get_node("/root/Game/World/Kanvas/UI/KeyRed").visible=true
	gravity=0.0
	velocity.y=0
	animation=true
