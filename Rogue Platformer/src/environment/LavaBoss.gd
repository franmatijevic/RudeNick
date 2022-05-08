extends Node2D

var up:=false

func _ready() -> void:
	get_node("Fire/Particles2D").process_material.color.r=244.0/255
	get_node("Fire/Particles2D").process_material.color.g=191.0/255
	get_node("Fire/Particles2D").process_material.color.b=66.0/255
	get_node("Fire/Particles2D").speed_scale=0.75
	get_node("Fire/Particles2D").process_material.spread=75
	get_node("Fire/Particles2D").lifetime=0.5


func _on_Detect_body_entered(body: Node) -> void:
	if(body.name=="Player"):
		body.last_damage="lava"
		body.death(true)
	else:
		body.death()

