extends KinematicBody2D

var speed: = 50.0
var velocity: = Vector2.ZERO
var hostile=false

var player: Object= null
var dir:= Vector2.ZERO

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()

func _on_damageBox_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").disabled=true
	queue_free()

func _on_playerDetect_body_entered(body: PhysicsBody2D) -> void:
	hostile=true
	get_node("AnimatedSprite").animation="flying"
	get_node("playerDetect/playerD").disabled=true


func _process(delta: float) -> void:
	if(get_parent().has_node("Player")): player = get_parent().get_node("Player")
	if(velocity.x>0): get_node("AnimatedSprite").set_flip_h(true)
	else: get_node("AnimatedSprite").set_flip_h(false)


func _physics_process(delta):
	if(hostile and get_parent().has_node("Player")):
		dir = Vector2( player.get_global_position() - get_global_position()).normalized()
		velocity=dir*speed
		move_and_slide(dir * speed)
