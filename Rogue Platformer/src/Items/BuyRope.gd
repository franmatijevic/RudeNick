extends KinematicBody2D

var gravity:=295.0
var speed:=Vector2(150.0, 100.0)
var velocity:=Vector2.ZERO

var player_near:=false

var price:=30

func _on_BuyIt_body_entered(body: Node) -> void:
	player_near=true

func _on_BuyIt_body_exited(body: Node) -> void:
	player_near=false

func _physics_process(delta: float) -> void:
	velocity.y+=gravity*delta
	move_and_slide(velocity)
	if(velocity.y>speed.y):
		velocity.y=speed.y

func _process(delta: float) -> void:
	if(player_near):
		if(Input.is_action_just_pressed("buy")):
			var player=get_parent().get_parent().get_node("Player")
			if(player.money>price-1):
				player.money-=price
				player.rope+=3
				queue_free()
