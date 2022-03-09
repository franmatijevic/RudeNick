extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=1
var just_rotated=0

var has_stopped:int=1
var old_coords:float
var newx


func _ready() -> void:
	get_node("AnimatedSprite").animation="default"
	velocity.x = speed.x
	$EdgeChecker.position.x=$CollisionShape2D.shape.get_extents().x;

func _on_spiderWeb_area_entered(area: Area2D) -> void:
	wait_and_stop()


func _on_spiderWeb_area_exited(area: Area2D) -> void:
	has_stopped=1
	can_move=1


func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	#get_node("CollisionShape2D").disabled = true
	#queue_free()

func _on_damagebox_area_entered(area: Area2D) -> void:
	death()

func _process(delta: float) -> void:
	if(velocity.x<0.0):
		direction=true
	else:
		direction=false
	if(can_move!=0):
		get_node("AnimatedSprite").set_flip_h( direction )

func _physics_process(delta: float) -> void:
	if((is_on_wall() or not $EdgeChecker.is_colliding()) and is_on_floor()):
		can_move=1
		velocity.x *= -1.0
		newx = int(round(global_position.x))/16
		newx = newx * 16 + 8
		global_position.x=newx
		$EdgeChecker.position.x=($CollisionShape2D.shape.get_extents().x+1)*(abs(velocity.x)/velocity.x)
		if(old_coords!=global_position.x):
			if(direction == true):
				direction = false
			else:
				direction = true
		else:
			can_move=0
		old_coords=newx
	else:
		if(old_coords!=global_position.x):
			can_move=1
	if(!is_on_floor()):
		can_move=1
	velocity.y = move_and_slide(velocity*can_move*has_stopped, Vector2.UP).y

func death()->void:
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	get_parent().add_child(blood)
	get_node("CollisionShape2D").disabled=true
	queue_free()

func wait_and_stop() ->void:
	has_stopped=0
	var time_in_seconds = 0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	can_move=0
