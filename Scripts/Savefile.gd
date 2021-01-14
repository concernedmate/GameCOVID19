extends Node


# Declare member variables here. Examples:
var scoreArray = [[800, "GAMER"], [500, "RIZ"]]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func writeSave():
	var saveGame = File.new()
	saveGame.open("user://highScore.save", File.WRITE)
	for i in scoreArray:
		var data = {
			"skor": i[0],
			"name": i[1],
			}
		saveGame.store_line(to_json(data))
	saveGame.close()

func loadSave():
	var saveGame = File.new()
	if !saveGame.file_exists("user://highScore.save"):
		return #no saves
	
	saveGame.open("user://highScore.save", File.READ)
	scoreArray = []
	while saveGame.get_position()<saveGame.get_len():
		var data = parse_json(saveGame.get_line())
		var player = [data["skor"], data["name"]]
		scoreArray.append(player)
	
	saveGame.close()

class customSorter:
	static func sort_descending(a, b):
		if a[0] > b[0]:
			return true
		else:
			return false

func urutkanData():
	scoreArray.sort_custom(customSorter, "sort_descending")


