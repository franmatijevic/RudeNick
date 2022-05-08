extends KinematicBody2D

var shake:=false
var time:float=0.0
var total_timer:float=0.0

var chains:=false
var k=-1

func _physics_process(delta: float) -> void:
	if(shake):
		get_node("Player").monitoring=false
		time+=delta
		total_timer+=delta
		if(time>0.1):
			chains=true
	if(chains==true):
		if(time>0.15):
			time=0.0
			k*=-1
			get_node("Chain1").position.y=1*k
			get_node("Chain2").position.y=-1*k
			get_node("Chain3").position.y=1*k
			get_node("Chain4").position.y=-1*k
	if(total_timer>0.75):
		shake=false
		if(has_node("CollisionShape2D")):
			get_node("CollisionShape2D").queue_free()
		global_position.y+=delta*50
		get_node("Chain1").position.y+=delta*8
		get_node("Chain2").position.y+=delta*5
		get_node("Chain3").position.y+=delta*3
		get_node("Chain4").position.y+=delta*2
	if(total_timer>5):
		queue_free()

func _on_Player_body_entered(body: Node) -> void:
	shake=true

