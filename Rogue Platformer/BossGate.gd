extends Node2D

var player


func _on_Player_body_entered(body: Node) -> void:
	player=true
	get_node("E").visible=true


func _on_Player_body_exited(body: Node) -> void:
	player=false
	get_node("E").visible=false

func _process(delta: float) -> void:
	if(player):
		if(Input.is_action_just_pressed("buy") and !get_node("/root/Game/World/Player").if_stunned):
			var n=0
			if(get_node("/root/Game").red_key):
				n=n+1
			if(get_node("/root/Game").green_key):
				n=n+1
			if(get_node("/root/Game").white_key):
				n=n+1
			if(n==3):
				enter_dungeon()
			elif(n==0):
				get_node("/root/Game/World/Kanvas/UI").print_something("It's locked shut! It looks like I need 3 keys...")
			elif(n==1):
				get_node("/root/Game/World/Kanvas/UI").print_something("I only have one key... Two to go!")
			elif(n==2):
				get_node("/root/Game/World/Kanvas/UI").print_something("I need just one more key!")

func enter_dungeon()->void:
	get_node("/root/Game/World/Player").dungeon_gate=true
	get_node("/root/Game/World").temple=true
	get_node("/root/Game").temple=true
	get_node("AnimatedSprite").visible=false
	get_node("Opened").visible=true
	get_node("E").visible=false
	get_node("/root/Game/World/Player").exitlevel()
	get_node("/root/Game").red_key=false
	get_node("/root/Game").green_key=false
	get_node("/root/Game").white_key=false
	get_node("/root/Game/World").temple=true
	var boss_level=get_node("/root/Game").level
	if(boss_level%2!=0):
		boss_level+=1
	boss_level=boss_level+int(boss_level/2)
	get_node("/root/Game").boss_level=boss_level
