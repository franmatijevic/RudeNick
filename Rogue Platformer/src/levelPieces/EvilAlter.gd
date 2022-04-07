extends Node2D

var player:=false
var one_sac:=false

func _on_DetectPlayer_body_entered(body: Node) -> void:
	get_node("E").visible=true
	player=true


func _on_DetectPlayer_body_exited(body: Node) -> void:
	get_node("E").visible=false
	player=false

func _process(delta: float) -> void:
	if(player and Input.is_action_just_pressed("buy")):
		get_node("/root/Game/World/Player").last_damage="Alter"
		
		if(get_node("/root/Game/World/Player").poisoned):
			var item=preload("res://src/Items/Cure.tscn").instance()
			item.position.x=0.0
			item.position.y=-6.5
			item.free=true
			add_child(item)
			var color=preload("res://src/Other/MoneyParticle.tscn").instance()
			color.get_node("Money").process_material.color=Color(0.773,0.055,0.902)
			color.get_node("Money").amount=80
			color.get_node("Money").emitting=true
			color.position.x=0.0
			color.position.y=-6.5
			add_child(color)
			get_parent().get_node("Kanvas/UI").print_something("God of death is pleased with your sacrifice.")
		elif(randi()%2==0):
			create_item()
			get_parent().get_node("Kanvas/UI").print_something("God of death is pleased with your sacrifice.")
		else:
			get_parent().get_node("Kanvas/UI").print_something("God of death seems happy")
		if(get_node("/root/Game/World/Player").health==1):
			if(get_node("/root/Game/World/Player").global_position.x>global_position.x):
				get_node("/root/Game/World/Player").death(true)
			else:
				get_node("/root/Game/World/Player").death(false)
		else:
			get_node("/root/Game/World/Player").damage(1)

func create_item()->void:
	var item
	match randi()%2:
		0:
			item=preload("res://src/Collectable/BombDrop.tscn").instance()
		1:
			item=preload("res://src/Collectable/RopeDrop.tscn").instance()
	item.position.x=0.0
	item.position.y=-6.5
	add_child(item)
	var color=preload("res://src/Other/MoneyParticle.tscn").instance()
	color.get_node("Money").process_material.color=Color(0.773,0.055,0.902)
	color.get_node("Money").amount=80
	color.get_node("Money").emitting=true
	color.position.x=0.0
	color.position.y=-6.5
	add_child(color)
