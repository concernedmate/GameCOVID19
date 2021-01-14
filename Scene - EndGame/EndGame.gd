extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pass # Replace with function body.


func _physics_process(delta):
	$Score.text = "SCORE  " + str(GlobalVariables.Score)
	$wave.text = "WAVE  " + str(GlobalVariables.waveCount)


func _on_TextureButton_button_up():
	if $inputnama.text != "":
		Savefile.scoreArray.push_back([GlobalVariables.Score, $inputnama.text])
		Savefile.urutkanData()
		if Savefile.scoreArray.size() > 10:
			Savefile.scoreArray.pop_back()
		Savefile.writeSave()
		GlobalVariables.reset()
		get_tree().change_scene("res://Scene - MainMenu/HighscoreMenu.tscn")
	else:
		$inputnama.placeholder_text = "INPUT NAMA"
	pass # Replace with function body.
