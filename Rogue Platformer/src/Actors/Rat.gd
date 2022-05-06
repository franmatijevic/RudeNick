extends "res://src/Actors/Actor.gd"

var direction: = false
var change: = false
var can_move=1
var health:=1
var just_rotated=0

var has_stopped:int=1
var old_coords:float
var newx

var last_damage="rat"

var scared:bool=false
var jumping:bool=false

var jump_speed:float=135.0

func _ready() -> void:
	#get_node("Ground").monitoring=false
	get_node("AnimatedSprite").animation="default"
	velocity.x = speed.x


func _physics_process(delta: float) -> void:
	if(scared and !jumping):
		jump()
	
	if($Player.is_colliding()):
		$Player.enabled=false
		speed.x=80
		scared=true
		if(get_node("AnimatedSprite").is_flipped_h()):
			velocity.x= -speed.x
			get_node("AnimatedSprite").set_flip_h(false)
			$Wall.cast_to.x= -13
			$Player.cast_to.x= -40
		else:
			velocity.x =speed.x
			get_node("AnimatedSprite").set_flip_h(true)
			$Wall.cast_to.x=13
			$Player.cast_to.x= 40
	
	
	if($Wall.is_colliding()):
		get_node("Ground").monitoring=false
		if(get_node("AnimatedSprite").is_flipped_h()):
			velocity.x= -speed.x
			get_node("AnimatedSprite").set_flip_h(false)
			$Wall.cast_to.x= -13
			$Player.cast_to.x= -40
		else:
			velocity.x =speed.x
			get_node("AnimatedSprite").set_flip_h(true)
			$Wall.cast_to.x=13
			$Player.cast_to.x=40
	
	
	velocity.y = move_and_slide(velocity).y

#func _process(delta: float) -> void:
#	pass

func jump()->void:
	jumping=true
	yield(get_tree().create_timer(1), "timeout")
	velocity.y=-jump_speed
	jumping=false

func destroy()->void:
	death()

func death()->void:
	var meat=preload("res://src/Collectable/RatMeat.tscn").instance()
	meat.global_position=global_position
	get_parent().add_child(meat)
	
	var blood=preload("res://src/Other/Blood.tscn").instance()
	blood.global_position=global_position
	get_parent().add_child(blood)
	get_node("CollisionShape2D").disabled=true
	queue_free()

func _on_Whip_area_entered(area: Area2D) -> void:
	death()


func _on_Head_body_entered(body: Node) -> void:
	if(body.global_position.y<global_position.y-5):
		body.enemy_jump()
		death()


func _on_Ground_body_entered(body: Node) -> void:
	queue_free()
