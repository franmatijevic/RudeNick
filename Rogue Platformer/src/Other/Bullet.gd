extends KinematicBody2D

var speed:=300


func _physics_process(delta: float) -> void:
	move_and_slide(speed*Vector2.RIGHT, Vector2.ZERO)

func _on_CollideWall_body_entered(body: Node) -> void:
	if(body.name=="Player"):
		body.last_damage="Mole-shotgun"
		if(body.health<3):
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			body.damage(2)
	queue_free()


func _on_DetectEnemy_body_entered(body: Node) -> void:
	body.death()
