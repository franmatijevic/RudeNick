extends Node2D

func _on_KillBeings_body_entered(body: Node) -> void:
	if(body.name=="Player"):
		body.last_damage="explosion"
		if(body.health<6):
			body.burned_death=true
			if(body.global_position.x>global_position.x):
				body.death(true)
			else:
				body.death(false)
		else:
			body.health=body.health-5
	else:
		body.death()

func _on_DetectBoss_area_entered(area: Area2D) -> void:
	area.get_parent().health-=5

func _on_BlockDMG_body_entered(body: Node) -> void:
	if(body.name!="Bedrock1" and body.name!="Bedrock2" and body.name!="Bedrock3" and body.name!="Bedrock4"):
		body.destroy()

func _on_BlockDMG_area_entered(area: Area2D) -> void:
	area.get_parent().queue_free()

func _ready() -> void:
	get_node("Sound").play()
	get_node("AnimatedSprite").frame=0
	remove()


func remove()->void:
	var time_in_seconds = 0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("KillBeings").monitoring=false
	time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	queue_free()
