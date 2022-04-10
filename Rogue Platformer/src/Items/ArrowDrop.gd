extends KinematicBody2D

var gravity=450.0

export var speed: = Vector2(50.0, 500.0)
var velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y
