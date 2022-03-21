extends "res://src/Actors/Actor.gd"

var angry:=false
var haty_down:=0.0
var haty_up:=0.0

func _ready() -> void:
	get_node("AnimatedSprite").animation="default"
	get_node("Shotgun").set_flip_h(get_node("AnimatedSprite").is_flipped_h())
	var pickhat=randi()%10
	var hat = get_node("AnimatedSprite/Hats")
	match pickhat:
		0:
			hat.animation="hat0"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		1:
			hat.animation="hat1"
			hat.set_flip_h(!get_node("AnimatedSprite").is_flipped_h())
			hat.position.x=1
		2:
			get_node("AnimatedSprite/Hats").animation="hat2"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		3:
			get_node("AnimatedSprite/Hats").animation="hat3"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		4:
			get_node("AnimatedSprite/Hats").animation="hat4"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		5:
			get_node("AnimatedSprite/Hats").animation="hat5"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		6:
			get_node("AnimatedSprite/Hats").animation="hat6"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		7:
			get_node("AnimatedSprite/Hats").animation="hat7"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		8:
			get_node("AnimatedSprite/Hats").animation="hat8"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
		9:
			get_node("AnimatedSprite/Hats").animation="hat9"
			hat.position.x=-0.5
			haty_up=-5
			haty_down=-4
	haty_down=haty_up+1

func _process(delta: float) -> void:
	if(!angry):
		if(get_node("AnimatedSprite").frame==0):
			get_node("AnimatedSprite/Hats").position.y=haty_up
		else:
			get_node("AnimatedSprite/Hats").position.y=haty_down
	else:
		get_node("AnimatedSprite").animation="walking"
		get_node("Shotgun").visible=true

func _physics_process(delta: float) -> void:
	pass
	

func death()->void:
	pass
