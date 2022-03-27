extends Node2D

func _on_Player_body_entered(body: Node) -> void:
	if(!body.is_on_floor() and body.velocity.y>0.0 and !body.climbing and body.global_position.y<global_position.y-1):
		body.last_damage="Spikes"
		body.spike_death=true
		body.death(true)


func _on_Enemy_body_entered(body: Node) -> void:
	if(!body.is_on_floor() and body.velocity.y>0.0):
		if(body.last_damage!="Bat"):
			body.death()
