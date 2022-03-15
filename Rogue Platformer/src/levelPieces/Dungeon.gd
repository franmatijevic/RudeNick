extends Node2D

var angry:bool=false

func _on_DetectBomb_area_entered(area):
	if(!angry):
		angry=true
		get_node("Troll").can_destroy=true
		get_node("Troll").angry=true
		get_node("Troll/BlockDestroy").monitoring=true
		get_node("Troll").speed.x*=1.6
		get_node("Troll").velocity.x*=1.6
		get_node("Troll/Sound1").play()
		if(area.global_position.x<global_position.x):
			get_node("Troll").velocity.x=abs(get_node("Troll").velocity.x)
		else:
			get_node("Troll").velocity.x*=-1
		get_node("Troll").can_move=1
		get_node("Troll/AnimatedSprite2").visible=true
		get_node("Troll/AnimatedSprite3").visible=false
		get_node("Troll").idle=false
		print("uuuhg")


