extends Node2D

var player:=false

func _physics_process(delta: float) -> void:
	if(!$Up.is_colliding()):
		if(player):
			get_node("/root/Game/World/Player").drop()
		queue_free()


func _on_Player_body_entered(body: Node) -> void:
	player=true


func _on_Player_body_exited(body: Node) -> void:
	player=false
