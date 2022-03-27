extends Control

var last:String=""

func _ready() -> void:
	pass
	if(get_node("/root/Game").poisoned):
		get_node("Poison").visible=true

func print_something(text: String)->void:
	last=text
	get_node("DialogText").text=text
	get_node("DialogText").visible_characters=0
	get_node("DialogBox").visible=true
	get_node("DialogText").visible=true
	for i in range(40):
		if(last!=text):
			break
		get_node("DialogText").visible_characters=i
		yield(get_tree().create_timer(0.05), "timeout")
	yield(get_tree().create_timer(2), "timeout")
	if(last==text):
		get_node("DialogBox").visible=false
		get_node("DialogText").visible=false
