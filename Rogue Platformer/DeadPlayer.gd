extends Actor

var knock:=false
var push:=150.0
var push_v:=100.0
var friction:=5.0

var spikes:=false

func _ready() -> void:
	get_parent().get_node("Kanvas").get_node("UI").get_node("health").text=str(0)
	if(!spikes):
		if(!knock):
			$Sprite.flip_h=true
			velocity.x+=push
			velocity.y-=push_v
		else:
			velocity.x-=push
			velocity.y-=push_v
	else:
		gravity/=8
		slow_blood()

func slow_blood()->void:
	var blood=preload("res://src/Other/Blood.tscn").instance()
	#blood.position=position
	#blood.global_position=global_position
	blood.lenght=3
	blood.get_node("Particles2D").amount=30
	blood.get_node("Particles2D").explosiveness=0.35
	get_parent().add_child(blood)

func _physics_process(delta: float) -> void:
	move_and_slide(velocity)
	if(velocity.x>0.0 and !velocity.y<0.0):
		velocity.x-=friction
	if(velocity.x<0.0 and !velocity.y<0.0):
		velocity.x+=friction
	
	if(is_on_wall()):
		velocity.x=0.0
	if(is_on_ceiling() and velocity.y<0.0):
		velocity.y=0.0
