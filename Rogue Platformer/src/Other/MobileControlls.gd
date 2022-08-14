extends CanvasLayer

func _ready() -> void:
	name="Mobile"
	flip(get_node("/root/Game").control_flip)

func flip(flip:bool)->void:
	if(!flip):
		get_node("Left").position.x=1451
		get_node("Right").position.x=1708
		get_node("Jump").position.x=387
		get_node("Attack").position.x=387
		get_node("Rope").position.x=54
		get_node("Bomb").position.x=54
		get_node("Up").position.x=1577
		get_node("Down").position.x=1577
		get_node("Interact").position.x=222
	else:
		get_node("Left").position.x=54
		get_node("Right").position.x=311
		get_node("Jump").position.x=1711
		get_node("Attack").position.x=1711
		get_node("Rope").position.x=1378
		get_node("Bomb").position.x=1378
		get_node("Up").position.x=180
		get_node("Down").position.x=180
		get_node("Interact").position.x=1546
