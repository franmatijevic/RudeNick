extends KinematicBody2D

var player
var speed:=215.0

var dir

func _ready() -> void:
	if(get_node("/root/Game/World").has_node("Player")):
		player=get_node("/root/Game/World/Player")
		dir = Vector2(player.global_position-global_position).normalized()
		get_node("Laser1").rotation_degrees=dir.angle()
		rotation = dir.angle()+90
	else:
		queue_free()


func _physics_process(delta: float) -> void:
	move_and_slide(dir * speed)


func _on_Wall_body_entered(body: Node) -> void:
	if(randi()%3==0):
		body.destroy()
	queue_free()


func _on_Player_body_entered(body: Node) -> void:
	if(body.name=="Player" and !body.iframes_on):
		body.last_damage="beholder"
		if(body.health<2):
			if(global_position.x<body.global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			body.damage(1)
