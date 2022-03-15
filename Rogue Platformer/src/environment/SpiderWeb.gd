extends KinematicBody2D

var lenght:=105
var collide=false
var player :Object = null

func _on_Area2D_body_entered(body: PhysicsBody2D) -> void:
	#player = get_parent().get_parent().get_node("Player")
	collide=true

func _on_Area2D_body_exited(body: Node) -> void:
	collide=false

func _physics_process(delta: float) -> void:
	return

func _ready() -> void:
	#if(get_parent().get_parent().has_node("Player")): 
	player = get_parent().get_node("Player")

func _process(delta: float) -> void:
	if(collide):
		if(player.velocity.x!=0 or player.velocity.y<0):
			lenght-=1
	if(lenght<=5): 
		remove()
	modulate.a=lenght/105.0

func remove()->void:
	queue_free()

func destroy()->void:
	queue_free()



