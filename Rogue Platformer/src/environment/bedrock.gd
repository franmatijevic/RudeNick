extends KinematicBody2D


func _ready() -> void:
	yield(get_tree().create_timer(1), "timeout")
	get_node("CollisionShape2D").disabled=false


