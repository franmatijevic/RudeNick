extends KinematicBody2D


func destroy()->void:
	var particles=preload("res://src/Other/BrickParticles.tscn").instance()
	particles.position=position
	get_parent().add_child(particles)
	queue_free()
