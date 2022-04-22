extends Node2D

var up:=false

func _ready() -> void:
	get_node("Fire/Particles2D").process_material.color.r=244.0/255
	get_node("Fire/Particles2D").process_material.color.g=191.0/255
	get_node("Fire/Particles2D").process_material.color.b=66.0/255
	get_node("Fire/Particles2D").speed_scale=0.75
	get_node("Fire/Particles2D").process_material.spread=75
	get_node("Fire/Particles2D").lifetime=0.5

func _physics_process(delta: float) -> void:
	if($Up.is_colliding()):
		up=true
	else:
		up=false
	
	if($Up.is_colliding() or $Hor_lava.get_collider().get_parent().up or $Hor_lava2.get_collider().get_parent().up):
		get_node("AnimatedSprite").visible=false
		get_node("LavaMid").visible=true
	else:
		get_node("AnimatedSprite").visible=true
		get_node("LavaMid").visible=false
	
	
	if(!$Left.is_colliding() or !$Right.is_colliding() or !$Down.is_colliding()):
		queue_free()


func _on_Detect_body_entered(body: Node) -> void:
	if(body.name=="Player"):
		body.last_damage="lava"
		body.death(true)
	else:
		body.death()
