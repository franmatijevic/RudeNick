extends Control

func _on_Quit_pressed() -> void:
	get_tree().quit()

func _button_pressed():
	print("Hello world!")

func _ready():
	var button = Button.new()
	button.text = "Click me"
	button.connect("pressed", self, "_button_pressed")
	add_child(button)
