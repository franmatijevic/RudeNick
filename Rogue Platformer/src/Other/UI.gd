extends Control

var is_printing:=false
var interupt:=false

var last:String=""

func _process(delta: float) -> void:
	if(is_printing):
		var i=0
		while(i<4):
			i+=delta

func print_something(text: String)->void:
	last=text
	if(is_printing):
		interupt=true
	is_printing=true
	get_node("DialogText").text=text
	get_node("DialogText").visible_characters=0
	get_node("DialogBox").visible=true
	get_node("DialogText").visible=true
	for i in range(35):
		if(last!=text):
			break
		get_node("DialogText").visible_characters=i
		yield(get_tree().create_timer(0.05), "timeout")
	yield(get_tree().create_timer(2.5), "timeout")
	is_printing=false
	interupt=false
	get_node("DialogBox").visible=false
	get_node("DialogText").visible=false
