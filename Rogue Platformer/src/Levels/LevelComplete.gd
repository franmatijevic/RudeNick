extends Node2D

var health:=0
var level:=0
var ropes:=0
var bomb:=0
var money:=0

var current_time:=0.0
var total_time:=0.0

func _ready() -> void:
	level=get_parent().level
	health=get_parent().player_health-get_parent().old_health
	ropes=get_parent().player_rope-get_parent().old_rope
	bomb=get_parent().player_bomb-get_parent().old_bomb
	money=get_parent().player_money-get_parent().old_money
	total_time=get_parent().total_time
	
	get_node("Kanvas/nice").text="Level " + str(level) + " Completed!"
	get_node("Kanvas/health").text=str(health)
	get_node("Kanvas/bombs").text=str(bomb)
	get_node("Kanvas/ropes").text=str(ropes)
	get_node("Kanvas/money").text=str(money*100)

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("buy")):
		get_parent().new_level()
