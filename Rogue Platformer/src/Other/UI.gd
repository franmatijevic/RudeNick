extends Control

var health:=4
var money:=0
var draw:=true

func _on_UI_draw() -> void:
	if(draw):
		$money.text = str(money*100)
		$health.text = str(health)


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func update_ui(m:int, h: int)->void:
	health=health
	money=m
	_on_UI_draw()


