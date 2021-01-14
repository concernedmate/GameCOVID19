extends Node2D

var spawnCD = 0 #cd per wave
var spawnDelay = 0 #delay per small group spawn
var waveFinished = false
var bossSpawned = false
var mapFinished = false

var npcSpawnDelay = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#jenis precil yg spawn pas boss wave
	GlobalVariables.areaBossEnemy = 3 #0 blastydios, 1 genidios, 2 laser, 3 spesial bossfight
	#camera limit, beda tergantung sama mapnya
	$Level/Player/Camera2D.limit_bottom = 825
	$Level/Player/Camera2D.limit_top = -576
	$Level/Player/Camera2D.limit_left = -172
	$Level/Player/Camera2D.limit_right = 1445

func spawnEnemy(delta):
	if spawnCD > 5:
		if spawnDelay>1 and (GlobalVariables.enemySpawned<GlobalVariables.waveEnemyCount or GlobalVariables.bossPhase):
			$Level/Spawner1.spawnEnemy()
			$Level/Spawner2.spawnEnemy()
			spawnDelay = 0
		else:
			spawnDelay += delta
	else:
		spawnCD += delta
		
func spawnNPC(delta):
	if GlobalVariables.npcExists == false:
		if npcSpawnDelay > 5:
			var randomChance = rand_range(0,100)
			if randomChance<50:
				if $Level/NPCSpawner1.onCamera==false:
					$Level/NPCSpawner1.spawnNPC()
					GlobalVariables.npcExists = true
					npcSpawnDelay = 0
			else:
				if $Level/NPCSpawner2.onCamera==false:
					$Level/NPCSpawner2.spawnNPC()
					GlobalVariables.npcExists = true
					npcSpawnDelay = 0
		else:
			npcSpawnDelay += delta

func doBossPhase(delta):
	if spawnCD > 5:
		if GlobalVariables.currentEnemyCount < 7 and GlobalVariables.bossAlive>0:
			if GlobalVariables.bossPhaseSpawnCreep:
				spawnEnemy(delta)
		
		if GlobalVariables.bossAlive <= 0 and GlobalVariables.currentEnemyCount<=0:
			get_node("Level/Player").playerHealth = GlobalVariables.playerMaxHealth
			GlobalVariables.waveCount += 1
			GlobalVariables.waveEnemyCount = 10 + GlobalVariables.waveCount*5
			GlobalVariables.enemySpawned = 0
			spawnCD = 0
			waveFinished = true
			GlobalVariables.bossPhase = false
			mapFinished = true
			
			$GUI/WaveClear.visible = true
			$GUI/WaveClear.frame = 0
			$GUI/WaveClear.play()
			
			$Audio/WaveClear.play()
	else:
		spawnCD += delta
		

func changeMap(delta):
	if spawnCD>5:
		if $GUI._on_changeMap_animation_finished():
			GlobalVariables.npcPosition = Vector2(0, 0)
			get_tree().change_scene("res://Scenes - Map/Map - Taman.tscn")
		GlobalVariables.npcExists = false
	else:
		if spawnCD>4:
			$GUI.playChangeMap()
			$Audio/BGM.stop()
			#$Audio/BGM_boss.stop()
		spawnCD+=delta
		
func _process(delta):
	if !mapFinished:
		doBossPhase(delta)
	else:
		changeMap(delta)
	
	if GlobalVariables.currentEnemyCount > 10 or GlobalVariables.bossPhase:
		spawnNPC(delta)


func _on_BGM_finished():
	if GlobalVariables.waveCount%5==0:
		$Audio/BGM.play()
	pass # Replace with function body.
