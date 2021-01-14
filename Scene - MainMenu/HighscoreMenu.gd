extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalVariables.inMainMenu = true
	Savefile.urutkanData()
	var names = ""
	var scores = ""
	for i in Savefile.scoreArray:
		names += i[1] + "\n"
		scores += str(i[0]) + "\n"
	$scoreNama.text = names
	$scoreNumber.text = scores


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_back_button_up():
	get_tree().change_scene("res://Scene - MainMenu/MainMenu.tscn")
	pass # Replace with function body.
