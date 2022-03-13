extends KinematicBody2D

var speed: = 50.0
var velocity: = Vector2.ZERO
var hostile=false

var begin:=false

var can_move=1

var last_damage:String="bat"

var player: Object= null
onready var dir:= Vector2.ZERO

func _on_Area2D_area_entered(area: Area2D) -> void:
	wait_and_stop()

func _on_spiderWeb_area_exited(area: Area2D) -> void:
	can_move=1

func _on_StompDetector_body_entered(body: PhysicsBody2D) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y-5:
		return
	death()

func _on_damageBox_area_entered(area: Area2D) -> void:
	death()

func _on_playerDetect_body_entered(body: PhysicsBody2D) -> void:
	hostile=true
	get_node("AnimatedSprite").animation="flying"
	get_node("playerDetect/playerD").disabled=true

func _ready() -> void:
	start_level()

func _process(delta: float) -> void:
	if(get_parent().has_node("Player") and get_parent().get_node("Player").exits_level):
		speed=1.5
	if(get_parent().has_node("Player")): player = get_parent().get_node("Player")
	if(can_move):
		if(velocity.x>0): get_node("AnimatedSprite").set_flip_h(true)
		else: get_node("AnimatedSprite").set_flip_h(false)


func _physics_process(delta):
	if(hostile and get_parent().has_node("Player") and begin):
		#dir = Vector2( player.get_global_position() - get_global_position()).normalized()
		dir = Vector2(player.global_position-global_position).normalized()
		velocity=dir*speed
		move_and_slide(dir * speed * can_move)

func start_level()->void:
	var time_in_seconds = 0.6
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	begin=true

func wait_and_stop() ->void:
	var time_in_seconds = 0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	can_move=0

func death()->void:
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	get_parent().add_child(blood)
	get_node("CollisionShape2D").disabled=true
	queue_free()
