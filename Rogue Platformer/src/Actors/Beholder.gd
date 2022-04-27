extends KinematicBody2D

export var speed: = Vector2(5.0, 1.0)
export var gravity: = 0.0
var using_gravity: = 1

var velocity: = Vector2.ZERO

func _ready() -> void:
	get_node("DestroyBlocks").monitoring=true
	gravity=0.0

var animation_direction=1

func _process(delta: float) -> void:
	get_node("AnimatedSprite").position.y+=delta*animation_direction*5
	if(get_node("AnimatedSprite").position.y>1):
		animation_direction=-1
	if(get_node("AnimatedSprite").position.y<-1):
		animation_direction=1

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * using_gravity
	if velocity.y > speed.y:
		velocity.y = speed.y
	
	velocity.y = move_and_slide(velocity).y
	if(Input.is_action_just_pressed("ui_accept")):
		shoot_small_laser()

func shoot_small_laser()->void:
	var laser = preload("res://src/Other/LaserSmall.tscn").instance()
	laser.position=position
	get_parent().add_child(laser)


func _on_DestroyBlocks_body_entered(body: Node) -> void:
	body.destroy()


func _on_Whip_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
