extends "res://src/Actors/Actor.gd"

var direction: = false

func _ready() -> void:
	velocity.x = speed.x
	$EdgeChecker.position.x=$CollisionShape2D.shape.get_extents().x;

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()
	
func _physics_process(delta: float) -> void:
	if is_on_wall() or not $EdgeChecker.is_colliding() and is_on_floor():
		velocity.x *= -1.0
		$EdgeChecker.position.x=$CollisionShape2D.shape.get_extents().x*(abs(velocity.x)/velocity.x)
		if(direction == true):
			direction = false
		else:
			direction = true
		get_node("AnimatedSprite").set_flip_h( direction )
	velocity.y = move_and_slide(velocity, Vector2.UP).y





func _on_damagebox_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").disabled=true
	queue_free()
