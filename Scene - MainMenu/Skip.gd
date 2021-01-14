extends Button


func _ready():
	pass
	
func _pressed():
	#randomize()
	#var chance = rand_range(0, 100)
	#if chance<30:
	#	get_tree().change_scene("res://Scenes - Map/Map - Taman.tscn")
	#elif chance<60:
	#	get_tree().change_scene("res://Scenes - Map/Map - Perumahan.tscn")
	#else:
	#	get_tree().change_scene("res://Scenes - Map/Map - Perkotaan.tscn")
	GlobalVariables.inMainMenu = false
	get_tree().change_scene("res://Scenes - Map/Map - Taman.tscn")
