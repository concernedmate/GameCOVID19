extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const NPC1 = preload("res://Scenes - Players and NPCs/NPC1.tscn")
var onCamera = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

func spawnNPC():
	if !onCamera:
		var npc
		var chance = rand_range(0, 100)
		if chance<25:
			npc = NPC1.instance()
		elif chance<50:
			npc = NPC1.instance()
		elif chance<75:
			npc = NPC1.instance()
		else:
			npc = NPC1.instance()
		get_parent().add_child(npc)
		npc.position = position
		GlobalVariables.npcPosition = global_position

func _on_VisibilityNotifier2D_screen_entered():
	onCamera = true


func _on_VisibilityNotifier2D_screen_exited():
	onCamera = false
