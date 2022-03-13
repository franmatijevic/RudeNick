extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=1

var last_damage:String="troll"

func _ready() -> void:
	get_node("AnimatedSprite").animation="default"
	velocity.x = speed.x
	#$EdgeChecker.position.x=$CollisionShape2D.shape.get_extents().x;

func _on_spiderWeb_area_entered(area: Area2D) -> void:
	area.queue_free()


func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	#get_node("CollisionShape2D").disabled = true
	#queue_free()

func _on_damagebox_area_entered(area: Area2D) -> void:
	death()

func _on_BlockDestroy_body_entered(body):
	var dust=preload("res://src/Other/Woodpiece.tscn").instance()
	dust.position=body.position
	get_parent().add_child(dust)
	body.queue_free()

func _process(delta: float) -> void:
	if(velocity.x>0.0):
		direction=true
	else:
		direction=false
	if(can_move!=0):
		get_node("AnimatedSprite").set_flip_h( direction )
		get_node("AnimatedSprite2").set_flip_h( direction )

func _physics_process(delta: float) -> void:
	if(is_on_wall() and is_on_floor()):
		velocity.x *= -1.0
	velocity.y = move_and_slide(velocity*can_move, Vector2.UP).y

func death()->void:
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	get_parent().add_child(blood)
	#get_node("CollisionShape2D").disabled=true
	#queue_free()
