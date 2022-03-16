extends KinematicBody2D

func _ready() -> void:
	z_index=5

func destroy()->void:
	get_node("CollisionShape2D").free()
	get_node("DirtParticles/Particles2D").rotation_degrees-=rotation_degrees
	get_node("Dirt").visible=false
	get_node("DirtParticles/Particles2D").emitting=true
	var time_in_seconds = 0.6
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	queue_free()
