extends KinematicBody2D
class_name Actor

export var speed: = Vector2(100.0, 1000.0)
export var gravity: = 1000.0

var velocity: = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if velocity.y > speed.y:
		velocity.y = speed.y
