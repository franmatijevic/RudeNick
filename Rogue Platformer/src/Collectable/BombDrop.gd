extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y

func _ready() -> void:
	wait()

func wait()->void:
	yield(get_tree().create_timer(0.2), "timeout")
	get_node("Player").monitoring=true

func _on_Player_body_entered(body: Node) -> void:
	body.bomb+=3
	queue_free()
