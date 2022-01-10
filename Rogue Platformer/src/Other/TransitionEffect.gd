extends CanvasLayer

var choice:=false

func _ready() -> void:
	if(choice==false):
		$AnimationPlayer.play("fade_to_normal")
	else:
		$AnimationPlayer.play("fade_to_black")

