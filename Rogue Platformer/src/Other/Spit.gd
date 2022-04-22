extends KinematicBody2D

var player
var speed:=250.0

var dir

func _ready() -> void:
	if(get_node("/root/Game/World").has_node("Player")):
		player=get_node("/root/Game/World/Player")
		dir = Vector2(player.global_position-global_position).normalized()
		get_node("WebSpit").rotation_degrees=dir.angle()
		rotation = dir.angle()
	else:
		queue_free()


func _physics_process(delta: float) -> void:
	move_and_slide(dir * speed)


func _on_Collide_body_entered(body: Node) -> void:
	if("last_damage" in body and body.last_damage=="bigspider"):
		return
	var web = preload("res://src/environment/SpiderWeb.tscn").instance()
	web.position=position
	get_parent().add_child(web)
	queue_free()
