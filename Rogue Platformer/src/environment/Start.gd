extends Node2D


func _ready() -> void:
	if(get_node("/root/Game/World").temple):
		get_node("DungeonDoors").visible=true
		get_node("Exit").visible=false


func _on_NoArrow_body_entered(body: Node) -> void:
	if(body.has_node("Up") and body.has_node("Left")):
		body.can_be_arrow=false
