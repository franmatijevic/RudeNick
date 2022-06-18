extends Node2D


func _ready() -> void:
	get_node("AnimatedSprite").frame=0
	yield(get_tree().create_timer(1), "timeout")
	get_node("AnimatedSprite").play()
	yield(get_tree().create_timer(3), "timeout")
	get_node("AnimatedSprite").visible=false
	get_parent().back_to_main_menu()

func _process(delta: float) -> void:
	if(get_node("AnimatedSprite").frame==4):
		get_node("Peek").playing=true
	if(get_node("AnimatedSprite").frame==10):
		get_node("Jump").playing=true
