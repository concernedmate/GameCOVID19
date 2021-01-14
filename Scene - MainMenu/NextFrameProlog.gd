extends AnimatedSprite

var current_frame = 0

func _ready():
	get_parent().connect("pressed",self,"NextFrame")
 
func NextFrame():
	if current_frame == 4 :
		GlobalVariables.inMainMenu = false
		get_tree().change_scene("res://Scenes - Map/Map - Taman.tscn")
		#randomize()
		#var chance = rand_range(0, 100)
		#if chance<30:
		#	get_tree().change_scene("res://Scenes - Map/Map - Taman.tscn")
		#elif chance<60:
		#	get_tree().change_scene("res://Scenes - Map/Map - Perumahan.tscn")
		#else:
		#	get_tree().change_scene("res://Scenes - Map/Map - Perkotaan.tscn")
	current_frame = (current_frame + 1) 
	set_frame(current_frame)
