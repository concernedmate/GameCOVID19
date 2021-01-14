extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const MUSUH_GIGIT = preload("res://Scenes - Players and NPCs/VirusGigit.tscn")
const MUSUH_NEMBAK = preload("res://Scenes - Players and NPCs/VirusNembak.tscn")
const MUSUH_LEDAK = preload("res://Scenes - Players and NPCs/VirusLedak.tscn")
const MUSUH_LASER = preload("res://Scenes - Players and NPCs/VirusLaser.tscn")
const MUSUH_SMOKE = preload("res://Scenes - Players and NPCs/VirusSmoke.tscn")
var onCamera = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.

func spawnEnemy():
	if !onCamera:
		var enemy
		if GlobalVariables.bossPhase == false:
			var type = rand_range(0, 10)
			if type < 5:
				type = rand_range(0, 10)
				if type < 5:
					enemy = MUSUH_GIGIT.instance()
				else:
					enemy = MUSUH_NEMBAK.instance()
					enemy.enemyTarget = get_node("/root/Root/Level/Player") 
			elif type < 7:
				enemy = MUSUH_LEDAK.instance()
				enemy.enemyTarget = get_node("/root/Root/Level/Player") 
			elif type < 9:
				enemy = MUSUH_LASER.instance()
				enemy.enemyTarget = get_node("/root/Root/Level/Player") 
			else:
				enemy = MUSUH_SMOKE.instance()
		else:
			match GlobalVariables.areaBossEnemy:
				0:
					enemy = MUSUH_GIGIT.instance()
				1:
					enemy = MUSUH_NEMBAK.instance()
					enemy.enemyTarget = get_node("/root/Root/Level/Player") 
				2:
					enemy = MUSUH_LASER.instance()
					enemy.enemyTarget = get_node("/root/Root/Level/Player") 
				3:
					var type = rand_range(0, 10)
					if type < 5:
						enemy = MUSUH_GIGIT.instance()
					else:
						enemy = MUSUH_NEMBAK.instance()
						enemy.enemyTarget = get_node("/root/Root/Level/Player") 
		get_parent().add_child(enemy)
		enemy.position = position
		GlobalVariables.currentEnemyCount += 1
		GlobalVariables.enemySpawned += 1
	
	


func _on_VisibilityNotifier2D_viewport_entered(_viewport):
	onCamera = true


func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	onCamera = false
