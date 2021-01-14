extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !GlobalVariables.tutorialFinished:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_parent().get_node("mouseAim").visible = false
		visible = true
	else:
		visible = false
		queue_free()


func _on_close_button_up():
	GlobalVariables.tutorialFinished = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().get_node("mouseAim").visible = true
	get_tree().paused = false
	pass # Replace with function body.
