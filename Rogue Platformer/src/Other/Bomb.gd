extends KinematicBody2D

var boom
var in_hands:=true

func _ready() -> void:
	boom=preload("res://src/Other/Expolsion.tscn").instance()
	wait()

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("bomb")):
		in_hands=false
	if(in_hands):
		follow_player()

func follow_player()->void:
	if(get_parent().has_node("Player")):
		position=get_parent().get_node("Player").position

func wait()->void:
	var time_in_seconds = 3
	yield(get_tree().create_timer(time_in_seconds), "timeout")
	boom.position=position
	get_parent().add_child(boom)
	queue_free()
