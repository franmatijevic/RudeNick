extends KinematicBody2D

var money:String="."

func _ready() -> void:
	z_index=5

func destroy()->void:
	get_node("CollisionShape2D").free()
	get_node("Money").visible=false
	get_node("DirtParticles/Particles2D").rotation_degrees-=rotation_degrees
	get_node("Dirt").visible=false
	get_node("DirtParticles/Particles2D").emitting=true
	
	if(money!="."):
		var gold=[0,0,0,0,0]
		if(money=="min"):
			gold[0]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[0].position=position
			gold[0].position.x+=5-randi()%11
			get_parent().add_child(gold[0])
		elif(money=="mid"):
			gold[0]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[1]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[2]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[0].position=position
			gold[0].position.x+=5-randi()%11
			gold[1].position=position
			gold[1].position.x+=5-randi()%11
			gold[2].position=position
			gold[2].position.x+=5-randi()%11
			get_parent().add_child(gold[0])
			get_parent().add_child(gold[1])
			get_parent().add_child(gold[2])
		elif(money=="max"):
			gold[0]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[1]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[2]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[3]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[4]=preload("res://src/Collectable/Gold1.tscn").instance()
			gold[0].position=position
			gold[0].position.x+=5-randi()%11
			gold[1].position=position
			gold[1].position.x+=5-randi()%11
			gold[2].position=position
			gold[2].position.x+=5-randi()%11
			gold[3].position=position
			gold[3].position.x+=5-randi()%11
			gold[4].position=position
			gold[4].position.x+=5-randi()%11
			get_parent().add_child(gold[0])
			get_parent().add_child(gold[1])
			get_parent().add_child(gold[2])
			get_parent().add_child(gold[3])
			get_parent().add_child(gold[4])
		elif(money=="emerald"):
			gold[0]=preload("res://src/Collectable/Emerald.tscn").instance()
			gold[0].position=position
			get_parent().add_child(gold[0])
		elif(money=="sapphire"):
			gold[0]=preload("res://src/Collectable/Sapphire.tscn").instance()
			gold[0].position=position
			get_parent().add_child(gold[0])
		elif(money=="ruby"):
			gold[0]=preload("res://src/Collectable/Ruby.tscn").instance()
			gold[0].position=position
			get_parent().add_child(gold[0])
	var time_in_seconds = 0.6
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	queue_free()
