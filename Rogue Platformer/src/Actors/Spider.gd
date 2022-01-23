extends "res://src/Actors/Actor.gd"

var hostile:=false
var is_jumping:=false
var first_fall:=false
var jump=210.0
var playerx
var spiderx

func _on_damageBox_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").disabled=true
	queue_free()

func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()

func jump()->void:
	if(is_jumping and is_on_floor()): 
		velocity.y-=jump
	is_jumping=true

func wait()->void:
	if(is_on_floor()):
		playerx=get_parent().get_node("Player").global_position.x
		spiderx=global_position.x
		var time_in_seconds = 2
		yield(get_tree().create_timer(time_in_seconds), "timeout")
		if(is_on_floor()):
			jump()


func _physics_process(delta: float) -> void:
	if(!$BlockAbove.is_colliding()):
		hostile=true
		$BlockAbove.enabled=false
	if($PlayerDetect.is_colliding()):
		hostile=true
	if(is_on_floor()): 
		first_fall=true
		if(is_jumping and velocity.y<0.0):
			is_jumping=false
	if(hostile):
		if(is_on_ceiling() and velocity.y<0.0):
			velocity.y=velocity.y
			is_jumping=false
		
		
		if(is_on_floor() and !is_jumping):
			is_jumping=true
			wait()
		
		get_node("AnimatedSprite").set_flip_v(false)
		using_gravity=1
		if(is_on_floor()): 
			$AnimatedSprite.animation="dance"
		else: 
			$AnimatedSprite.animation="jumping"
		
		
		if(first_fall and !is_on_floor()):
			if(playerx>=spiderx):
				velocity.x=speed.x
				get_node("AnimatedSprite").set_flip_h(true)
			else: 
				velocity.x=-speed.x
				get_node("AnimatedSprite").set_flip_h(false)
		else: velocity.x=0.0
	else:
		get_node("AnimatedSprite").set_flip_v(true)
		using_gravity=0
	
	velocity=move_and_slide(velocity, Vector2.UP*using_gravity)





