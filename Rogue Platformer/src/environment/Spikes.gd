extends Node2D

func _on_Player_body_entered(body: Node) -> void:
	if(!body.is_on_floor() and body.velocity.y>0.0 and !body.climbing and body.global_position.y<global_position.y-3):
		body.last_damage="Spikes"
		body.spike_death=true
		body.death(true)
		get_node("Spike1").visible=false
		get_node("Spike2").visible=false
		get_node("Blood1").visible=true
		get_node("Blood2").visible=true


func _on_Enemy_body_entered(body: Node) -> void:
	if(!body.is_on_floor() and body.velocity.y>0.0):
		if(body.last_damage!="Bat"):
			body.death()
			get_node("Spike1").visible=false
			get_node("Spike2").visible=false
			get_node("Blood1").visible=true
			get_node("Blood2").visible=true
