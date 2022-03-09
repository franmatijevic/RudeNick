extends KinematicBody2D

var speed:=300.0
var back_speed:=5000.0
var end
var start
var distance:=80
var newx

var maks=6

var crash:=false
var start_creating:=false

func _ready() -> void:
	newx = int(round(global_position.x))/16
	newx = newx * 16 + 8
	var newy = int(round(global_position.y))/16
	newy = newy * 16 + 8
	global_position.x=newx
	global_position.y=newy
	end=newy-distance
	start=newy

func crash()->void:
	if(has_node("Damage")):
		get_node("Damage").queue_free()
	if(has_node("LadderTop")):
		get_node("LadderTop").queue_free()
	var newy = int(round(global_position.y))/16
	newy = newy * 16 + 8
	#speed=-back_speed
	speed=0.0
	var ladder=preload("res://src/environment/RopeTopPart.tscn").instance()
	ladder.global_position=global_position
	get_parent().add_child(ladder)

func create_rest():
	if(!start_creating):
		start_creating=true
		var time_in_seconds = 0.01
		var array = [0,0,0,0,0,0]
		var n:=0
		maks=6
		for i in range(maks):
			if(i==0):
				i=1
			global_position.y=end+i*16
			if(i==maks-1 or $Floor.is_colliding()):
				array[i] = preload("res://src/environment/RopeBot.tscn").instance()
			else:
				array[i] = preload("res://src/environment/RopeMid.tscn").instance()
			yield(get_tree().create_timer(time_in_seconds), "timeout")
			array[i].global_position.x=newx
			array[i].global_position.y=end
			array[i].global_position.y+=i*16
			get_parent().add_child(array[i])
			n=n+1
			if($Floor.is_colliding()):
				queue_free()
		var rope
		match n:
			1:
				rope=preload("res://src/environment/RopeTopPart.tscn").instance()
			2:
				rope=preload("res://src/Ropes/Rope2.tscn").instance()
			3:
				rope=preload("res://src/Ropes/Rope3.tscn").instance()
			4:
				rope=preload("res://src/Ropes/Rope4.tscn").instance()
			5:
				rope=preload("res://src/Ropes/Rope5.tscn").instance()
			6:
				rope=preload("res://src/Ropes/Rope6.tscn").instance()
		#rope.global_position=global_position
		#get_parent().add_child(rope)
		queue_free()

func _physics_process(delta: float) -> void:
	if(!crash):
		move_and_slide(Vector2(0.0, -speed))
		if(global_position.y<=end or $Ceiling.is_colliding()):
			if($Ceiling.is_colliding()):
				end=$Ceiling.get_collider().global_position.y+16
			crash()
			crash=true
	else:
		create_rest()
