extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO

var player:=false


func _on_DetectPlayer_body_entered(body: Node) -> void:
	get_node("E").visible=true
	player=true


func _on_DetectPlayer_body_exited(body: Node) -> void:
	get_node("E").visible=false
	player=false

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y

func _process(delta: float) -> void:
	if(player):
		if(Input.is_action_just_pressed("buy")):
			get_node("/root/Game/World/Player").shotgun+=5
			get_node("DetectPlayer").monitoring=false
			get_node("/root/Game/Reload").play()
			queue_free()
