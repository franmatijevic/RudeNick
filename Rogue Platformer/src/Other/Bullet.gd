extends KinematicBody2D

var speed:=300
var player:=false

func _physics_process(delta: float) -> void:
	move_and_slide(speed*Vector2.RIGHT, Vector2.ZERO)

func _on_CollideWall_body_entered(body: Node) -> void:
	if(body.name=="Player" and !body.iframes_on and !player):
		body.last_damage="Mole"
		if(body.health<3):
			if(speed>0.0):
				body.death(true)
			else:
				body.death(false)
		else:
			body.damage(2)
	if("last_damage" in body and body.last_damage=="serpant"):
		print("miss ya")
	elif(!player or !body.name=="Player"):
		queue_free()


func _on_DetectEnemy_body_entered(body: Node) -> void:
	if(body.last_damage=="Troll" or body.last_damage=="serpant" or body.last_damage=="bigspider"):
		body.damage(2)
	elif(body.last_damage=="Mole" and player):
		body.damage(2)
		if(!body.angry):
			body.get_parent().get_mad()
	if(body.last_damage!="Troll" and body.last_damage!="Mole" and body.last_damage!="serpant" and body.last_damage!="bigspider"):
		body.death()
	if(body.last_damage=="Mole" and !player):
		pass
	else:
		queue_free()


func _on_BoneBlock_body_entered(body: Node) -> void:
	body.destroy()
	queue_free()
