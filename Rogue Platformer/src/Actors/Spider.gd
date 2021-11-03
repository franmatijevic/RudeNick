extends KinematicBody2D

var hostile:=false

func _on_damageBox_area_entered(area: Area2D) -> void:
	get_node("CollisionShape2D").disabled=true
	queue_free()

func _on_StompDetector_body_entered(body: Node) -> void:
	if body.global_position.y >= get_node("StompDetector").global_position.y:
		return
	get_node("CollisionShape2D").disabled = true
	queue_free()


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	if(hostile):
		pass

func _physics_process(delta: float) -> void:
	if(hostile):
		pass
	else:
		get_node("AnimatedSprite").set_flip_v(true)





