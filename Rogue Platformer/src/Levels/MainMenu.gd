extends Node2D

func title_animation()->void:
	var time_in_seconds = 0.5
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("AnimatedSprite").animation="playing"
	time_in_seconds=0.1
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	get_node("RudeNick").visible=true
	get_node("PlayButton").visible=true
	get_node("HelpButton").visible=true
	get_node("QuitButton").visible=true
	get_node("AnimatedSprite").queue_free()


func _ready() -> void:
	title_animation()
