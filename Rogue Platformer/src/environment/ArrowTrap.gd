extends KinematicBody2D

var dir:bool=false
var do_what_must_be_done:=false

func _ready() -> void:
	if(dir):
		$Detect.cast_to.x*=-1
		get_node("ArrowTrap").set_flip_h(false)
	
	wait()

func _physics_process(delta: float) -> void:
	if($Detect.is_colliding()):
		var collider = $Detect.get_collider()
		if(collider.name=="Player"):
			shoot()
		elif(collider.has_node("Dirt")):
			pass
		elif("velocity" in collider and (collider.velocity.x!=0.0 or collider.velocity.y!=0.0)):
			shoot()

func shoot()->void:
	$Detect.enabled=false
	var arrow=preload("res://src/Items/Arrow.tscn").instance()
	arrow.position=position
	if(!dir):
		arrow.speed=-arrow.speed
		arrow.position.x-=9
	else:
		arrow.position.x+=9
	get_parent().add_child(arrow)

func wait()->void:
	yield(get_tree().create_timer(0.5), "timeout")
	$Detect.enabled=true

func destroy()->void:
	queue_free()
