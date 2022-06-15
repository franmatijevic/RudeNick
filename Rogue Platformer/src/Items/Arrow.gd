extends KinematicBody2D

var gravity:=0.0

var exit:=false

var velocity: = Vector2.ZERO
var speed=450.0

func _ready() -> void:
	get_node("Sound").play()
	velocity.x=speed
	if(speed<0):
		get_node("Arrow").set_flip_h(true)

func _physics_process(delta: float) -> void:
	#velocity.y+=gravity*delta
	move_and_slide(velocity)
	#if(velocity.y>speed.y):
	#	velocity.y=speed.y
	if(is_on_wall()):
		speed=0.0
		gravity=-50.0
		get_node("DetectPlayer").monitoring=false

func _on_DetectPlayer_body_entered(body: Node) -> void:
	body.last_damage="arrow"
	if(body.iframes_on):
		return
	if(body.health<3):
		if(speed>0.0):
			body.death(true)
		else:
			body.death(false)
	else:
		body.damage(2)
		body.stunned()
		body.using_gravity=1
	var chest=preload("res://src/Items/ArrowDrop.tscn").instance()
	chest.position=position
	get_parent().add_child(chest)
	queue_free()
	speed=0.0
	gravity=-50.0
	get_node("DetectPlayer").monitoring=false


func _on_Ground_body_entered(body: Node) -> void:
	if(!exit):
		exit=true
	else:
		gravity=-100.0
		queue_free()
		get_node("DetectPlayer").monitoring=false
		var chest=preload("res://src/Items/ArrowDrop.tscn").instance()
		chest.position=position
		get_parent().add_child(chest)
		queue_free()


func _on_Ground_body_exited(body: Node) -> void:
	if(exit):
		gravity=-100.0
		#queue_free()


func _on_DetectEnemy_body_entered(body: Node) -> void:
	body.death()
	var chest=preload("res://src/Items/ArrowDrop.tscn").instance()
	chest.position=position
	get_parent().add_child(chest)
	queue_free()


func _on_Whip_area_entered(area: Area2D) -> void:
	var chest=preload("res://src/Items/ArrowDrop.tscn").instance()
	chest.position=position
	get_parent().add_child(chest)
	queue_free()


func _on_Boss_area_entered(area: Area2D) -> void:
	area.get_parent().damage(2)
	var chest=preload("res://src/Items/ArrowDrop.tscn").instance()
	chest.position=position
	get_parent().add_child(chest)
	queue_free()


func _on_BoneBlock_body_entered(body: Node) -> void:
	body.destroy()
	var chest=preload("res://src/Items/ArrowDrop.tscn").instance()
	chest.position=position
	get_parent().add_child(chest)
	queue_free()
