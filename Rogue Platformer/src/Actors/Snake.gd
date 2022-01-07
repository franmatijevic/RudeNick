extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=1

func _ready() -> void:
	velocity.x = speed.x
	$EdgeChecker.position.x=$CollisionShape2D.shape.get_extents().x;

func _on_spiderWeb_area_entered(area: Area2D) -> void:
	wait_and_stop()


func _on_spiderWeb_area_exited(area: Area2D) -> void:
	can_move=1


func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _on_damagebox_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").disabled=true
	queue_free()

func _process(delta: float) -> void:
	if(change==false): get_node("AnimatedSprite").set_flip_h( direction )

func _physics_process(delta: float) -> void:
	#if(change==true): get_node("AnimatedSprite").set_flip_h( direction )
	if((is_on_wall() or not $EdgeChecker.is_colliding()) and is_on_floor()):
		velocity.x *= -1.0
		change=true
		$EdgeChecker.position.x=$CollisionShape2D.shape.get_extents().x*(abs(velocity.x)/velocity.x)
		if(direction == true):
			direction = false
		else:
			direction = true
		change=true
	else: change=false
	velocity.y = move_and_slide(velocity * can_move, Vector2.UP).y

func wait_and_stop() ->void:
	var time_in_seconds = 0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	can_move=0

