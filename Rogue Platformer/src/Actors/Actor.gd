extends KinematicBody2D
class_name Actor

export var speed: = Vector2(5.0, 1.0)
export var gravity: = 500.0
var using_gravity: = 1

var velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * using_gravity
	if velocity.y > speed.y:
		velocity.y = speed.y
