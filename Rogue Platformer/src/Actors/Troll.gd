extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=20

var angry:bool=false
var idle:bool=false

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
	if(body.name!="Bedrock1" and body.name!="Bedrock2" and body.name!="Bedrock3" and body.name!="Bedrock4"):
		body.destroy()

func _on_BlockDestroy_area_entered(area: Area2D) -> void:
	area.destroy()

func _process(delta: float) -> void:
	if(velocity.x>0.0):
		direction=true
		get_node("BlockDestroy").position.x=15
		get_node("BlockDestroy/CollisionShape2D2").position.x=4
	else:
		direction=false
		get_node("BlockDestroy").position.x=-15
		get_node("BlockDestroy/CollisionShape2D2").position.x=-4
	if(can_move!=0):
		get_node("AnimatedSprite").set_flip_h( direction )
		get_node("AnimatedSprite2").set_flip_h( direction )

func _physics_process(delta: float) -> void:
	if(is_on_wall() and is_on_floor()):
		velocity.x *= -1.0
	if(!idle and !angry):
		idle()
	
	velocity.y = move_and_slide(velocity*can_move, Vector2.UP).y

func death()->void:
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	get_parent().add_child(blood)
	#get_node("CollisionShape2D").disabled=true
	#queue_free()

func idle()->void:
	idle=true
	can_move=0
	get_node("AnimatedSprite2").visible=false
	get_node("AnimatedSprite3").visible=true
	var time_in_seconds = 3
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	can_move=1
	get_node("AnimatedSprite2").visible=true
	get_node("AnimatedSprite3").visible=false
	time_in_seconds = 5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	idle=false
