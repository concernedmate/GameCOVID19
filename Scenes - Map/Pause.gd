extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weaponType = get_node("/root/Root/Level/Player").weaponType
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			get_tree().paused = false
			$PauseMessage.visible = false
			get_parent().get_node("mouseAim").visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			get_tree().paused = true
			$PauseMessage.visible = true
			get_parent().get_node("mouseAim").visible = false
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#set pointer
	get_parent().get_node("mouseAim").position = get_global_mouse_position()
	get_parent().get_node("mouseAim").frame = weaponType


func _on_Pause_pressed():
	if get_tree().paused:
		get_tree().paused = false
		$PauseMessage.visible = false
		get_parent().get_node("mouseAim").visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		get_tree().paused = true
		$PauseMessage.visible = true
		get_parent().get_node("mouseAim").visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_keluar_button_up():
	get_tree().paused = false
	GlobalVariables.reset()
	get_tree().change_scene("res://Scene - MainMenu/MainMenu.tscn")
	pass # Replace with function body.


func _on_continue_button_up():
	get_tree().paused = false
	$PauseMessage.visible = false
	get_parent().get_node("mouseAim").visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.

