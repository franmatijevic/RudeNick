extends KinematicBody2D


func _ready() -> void:
	if(get_node("/root/Game/World").has_node("Beholder")):
		get_node("CollisionShape2D").disabled=false
	yield(get_tree().create_timer(1), "timeout")
	get_node("CollisionShape2D").disabled=false


