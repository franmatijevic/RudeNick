extends Control

var health:=4
var money:=0
var draw:=true

func _on_UI_draw() -> void:
	if(draw):
		$money.text = str(money*100)
		$health.text = str(health)


