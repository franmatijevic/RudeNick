extends Actor

var knock:=false
var push:=150.0
var push_v:=100.0
var friction:=5.0

func _ready() -> void:
	if(!knock):
		velocity.x+=push
		velocity.y-=push_v
	else:
		velocity.x-=push
		velocity.y-=push_v

func _physics_process(delta: float) -> void:
	global_position.y+=delta*15
	velocity.y =move_and_slide(velocity).y
	if(velocity.x>0.0 and !velocity.y<0.0):
		velocity.x-=friction
	if(velocity.x<0.0 and !velocity.y<0.0):
		velocity.x+=friction
	
	if(abs(velocity.x)<30):
		velocity.y=100


func _on_Wall_body_entered(body: Node) -> void:
	var snake1=preload("res://src/Actors/Snake.tscn").instance()
	var snake2=preload("res://src/Actors/Snake.tscn").instance()
	
	if(randi()%20==0):
		snake1=preload("res://src/Actors/BlackSnake.tscn").instance()
	if(randi()%20==0):
		snake2=preload("res://src/Actors/BlackSnake.tscn").instance()
	
	snake1.position=position
	get_parent().add_child(snake1)
	snake2.position=position
	get_parent().add_child(snake2)
	queue_free()


func _on_Whip_area_entered(area: Area2D) -> void:
	var color=preload("res://src/Other/MoneyParticle.tscn").instance()
	color.get_node("Money").process_material.color=Color(0.27,0.51,0.20)
	color.get_node("Money").emitting=true
	color.position=position
	get_parent().add_child(color)
	queue_free()
