extends KinematicBody2D

var player
var speed:=275.0

var dir

func _ready() -> void:
	if(get_node("/root/Game/World").has_node("Player")):
		player=get_node("/root/Game/World/Player")
		dir = Vector2(player.global_position-global_position).normalized()
	else:
		queue_free()

func _physics_process(delta: float) -> void:
	if(dir!=null):
		move_and_slide(dir * speed)

func _on_Crash_body_entered(body: Node) -> void:
	if(body.name=="Beholder"):
		return
	var boom=preload("res://src/Other/Expolsion.tscn").instance()
	boom.last_damage="beholder"
	boom.position=position
	get_parent().add_child(boom)
	queue_free()
