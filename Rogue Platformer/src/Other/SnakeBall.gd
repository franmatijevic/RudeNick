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
	move_and_slide(velocity)
	if(velocity.x>0.0 and !velocity.y<0.0):
		velocity.x-=friction
	if(velocity.x<0.0 and !velocity.y<0.0):
		velocity.x+=friction
	if(abs(velocity.x)<30):
		velocity.y=100


func _on_Wall_body_entered(body: Node) -> void:
	var snake1=preload("res://src/Actors/Snake.tscn").instance()
	var snake2=preload("res://src/Actors/Snake.tscn").instance()
	
	if(randi()%20):
		snake1=preload("res://src/Actors/BlackSnake.tscn").instance()
	if(randi()%20):
		snake2=preload("res://src/Actors/BlackSnake.tscn").instance()
	
	snake1.position=position
	get_parent().add_child(snake1)
	snake2.position=position
	get_parent().add_child(snake2)
	queue_free()
