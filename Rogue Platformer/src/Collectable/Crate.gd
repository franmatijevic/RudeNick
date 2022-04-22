extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 300.0)
var velocity:=Vector2.ZERO

var dropped:=false

func _on_Boom_area_entered(area: Area2D) -> void:
	destroy()
	queue_free()

func _on_Whip_area_entered(area: Area2D) -> void:
	destroy()
	queue_free()

func destroy()->void:
	var drop=randi()%2
	var item
	match drop:
		0:
			item=preload("res://src/Items/BuyRope.tscn").instance()
		1:
			item=preload("res://src/Items/BuyBomb.tscn").instance()
	if(get_node("/root/Game/World").has_node("Player") and get_node("/root/Game/World/Player").poisoned and randi()%3==0):
		item=preload("res://src/Items/Cure.tscn").instance()
	item.free=true
	item.get_node("E").scale.x=0
	item.get_node("E").scale.y=0
	item.get_node("Text").scale.x=0
	item.get_node("Text").scale.y=0
	item.position=position
	var wood=preload("res://src/Other/Woodpiece.tscn").instance()
	wood.position=position
	if(!dropped):
		get_parent().add_child(wood)
		get_parent().add_child(item)
		dropped=true
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y


func _on_Whip_body_entered(body: Node) -> void:
	destroy()
	queue_free()
