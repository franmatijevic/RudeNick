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
		gravity/=35
		slow_blood()

func slow_blood()->void:
	$Blood.lenght=5
	$Blood.get_node("Particles2D").amount=60
	$Blood.get_node("Particles2D").explosiveness=0.2

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


func _on_DetectSpikes_area_entered(area: Area2D) -> void:
	velocity.x=0.0
	velocity.y=0.0
	gravity/=35
	area.get_parent().get_node("Spike1").visible=false
	area.get_parent().get_node("Spike2").visible=false
	area.get_parent().get_node("Blood1").visible=true
	area.get_parent().get_node("Blood2").visible=true
