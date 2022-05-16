extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO

var animation:=false

var price:int=100
var e:=false
var free:=false

var value:int=2

func _ready() -> void:
	get_node("Text/price").text="$"+str(price*100)

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y

func _process(delta: float) -> void:
	#if(e):
	#	get_node("E").visible=true
	#	get_node("Text/price").visible=true
	#else:
	#	get_node("E").visible=false
	#	get_node("Text/price").visible=false
	if(animation):
		get_node("CanOfBeans").position.y-=delta*90
		get_node("CanOfBeans").scale.x+=delta*0.6
		get_node("CanOfBeans").scale.y+=delta*0.6
		get_node("CanOfBeans").modulate.a-=delta*1.5
		if(get_node("CanOfBeans").modulate.a<0):
			queue_free()


func e()->void:
	if(free):
		get_parent().get_parent().get_node("Player").health+=value
		value=0
		play_animation()
	return
	e=true
	var time_in_seconds = 0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	e=false


func buy()->void:
	var player=get_parent().get_parent().get_node("Player")
	if(player.money>price-1):
		player.money-=price
		player.health+=value
		value=0
		get_parent().count_items()
		play_animation()
		get_node("E").scale.x=0
		get_node("E").scale.y=0
		get_node("Text").scale.x=0
		get_node("Text").scale.y=0
	else:
		get_node("/root/Game/World/BuyItemFail").play()

func get_for_free()->void:
	get_parent().get_parent().get_node("Player").health+=value
	value=0
	play_animation()

func play_animation()->void:
	gravity=0.0
	velocity.y=0.0
	set_collision_layer_bit(15,false)
	animation=true
	z_index=10


func _on_Player_body_exited(body: Node) -> void:
	get_node("E").visible=false
	get_node("Text/price").visible=false


func _on_Player_body_entered(body: Node) -> void:
	get_node("E").visible=true
	get_node("Text/price").visible=true
