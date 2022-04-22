extends Node2D

var health:=0
var level:=0
var ropes:=0
var bomb:=0
var money:=0

var current_time:=0.0
var total_time:=0.0

var temple=false

func _ready() -> void:
	if(get_node("/root/Game").poisoned):
		get_node("WalkingPlayerAnim/AnimatedSprite").modulate.r=0.27
		get_node("WalkingPlayerAnim/AnimatedSprite").modulate.g=0.51
		get_node("WalkingPlayerAnim/AnimatedSprite").modulate.b=0.20
	
	level=get_parent().level
	health=get_parent().player_health-get_parent().old_health
	ropes=get_parent().player_rope-get_parent().old_rope
	bomb=get_parent().player_bomb-get_parent().old_bomb
	money=get_parent().player_money-get_parent().old_money
	total_time=get_parent().total_time
	current_time=get_parent().current_time

	
	get_node("Kanvas/nice").text="Level " + str(level) + " Completed!"
	get_node("Kanvas/health").text=str(health)
	get_node("Kanvas/bombs").text=str(bomb)
	get_node("Kanvas/ropes").text=str(ropes)
	get_node("Kanvas/money").text=str(money*100)
	
	var minutes=floor(current_time/60.0)
	var seconds=int(current_time)%60
	if(seconds>9):
		get_node("Kanvas/time_n").text=str(minutes)+":"+str(seconds)
	else:
		get_node("Kanvas/time_n").text=str(minutes)+":0"+str(seconds)
	
	minutes=floor(total_time/60.0)
	seconds=int(total_time)%60
	if(seconds>9):
		get_node("Kanvas/total_n").text=str(minutes)+":"+str(seconds)
	else:
		get_node("Kanvas/total_n").text=str(minutes)+":0"+str(seconds)



func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("buy")):
		get_parent().new_level()
