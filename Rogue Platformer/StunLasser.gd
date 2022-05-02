extends KinematicBody2D

var player
var speed:=215.0

var dir

func _ready() -> void:
	if(get_node("/root/Game/World").has_node("Player")):
		player=get_node("/root/Game/World/Player")
		dir = Vector2(player.global_position-global_position).normalized()
	else:
		queue_free()


func _physics_process(delta: float) -> void:
	if(dir!=null):
		move_and_slide(dir * speed)

func _on_Wall_body_entered(body: Node) -> void:
	queue_free()


func _on_Player_body_entered(body: Node) -> void:
	if(body.name=="Player" and !body.iframes_on):
		body.last_damage="beholder"
		if(!body.if_stunned):
			body.stunned()
		if(body.health<2):
			if(global_position.x<body.global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			body.damage(1)
	queue_free()


func _on_Enemy_body_entered(body: Node) -> void:
	body.death()
	queue_free()
