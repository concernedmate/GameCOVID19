extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const BOSS_BLASTYDIOS = preload("res://Scenes - Bosses/BossBlastydios.tscn")
const BOSS_GENIDIOS = preload("res://Scenes - Bosses/BossGenidios.tscn")
const BOSS_SEGARADIOS = preload("res://Scenes - Bosses/BossSegaradios.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func spawnBoss():
	#todo 
	var musuh
	match GlobalVariables.areaBossEnemy:
		0:
			musuh = BOSS_BLASTYDIOS.instance()
		1:
			musuh = BOSS_GENIDIOS.instance()
		2:
			musuh = BOSS_SEGARADIOS.instance()
	
	get_parent().add_child(musuh)
	musuh.position = position
	
	pass

func spawnBoss2():
	#todo 
	var musuh
	var musuh2
	match GlobalVariables.areaBossEnemy:
		0:
			musuh = BOSS_BLASTYDIOS.instance()
			musuh2 = BOSS_GENIDIOS.instance()
		1:
			musuh2 = BOSS_SEGARADIOS.instance()
			musuh = BOSS_GENIDIOS.instance()
		2:
			musuh2 = BOSS_BLASTYDIOS.instance()
			musuh = BOSS_SEGARADIOS.instance()
	
	get_parent().add_child(musuh)
	get_parent().add_child(musuh2)
	musuh.position = position + Vector2 (-100, 0)
	musuh2.position = position + Vector2 (100, 0)
	
	pass

func spawnBoss3():
	#todo 
	var musuh
	var musuh2
	var musuh3
	match GlobalVariables.areaBossEnemy:
		0:
			musuh = BOSS_BLASTYDIOS.instance()
			musuh2 = BOSS_GENIDIOS.instance()
			musuh3 = BOSS_SEGARADIOS.instance()
		1:
			musuh = BOSS_BLASTYDIOS.instance()
			musuh2 = BOSS_GENIDIOS.instance()
			musuh3 = BOSS_SEGARADIOS.instance()
		2:
			musuh = BOSS_BLASTYDIOS.instance()
			musuh2 = BOSS_GENIDIOS.instance()
			musuh3 = BOSS_SEGARADIOS.instance()
	
	get_parent().add_child(musuh)
	get_parent().add_child(musuh2)
	get_parent().add_child(musuh3)
	musuh.position = position + Vector2 (-200, 0)
	musuh2.position = position + Vector2 (0, 0)
	musuh3.position = position + Vector2 (200, 0)
	
	pass
