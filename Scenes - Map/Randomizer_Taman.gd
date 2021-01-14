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
	GlobalVariables.areaBossEnemy = 0  #0 blastydios, genidios, 2 laser
	#camera limit, beda tergantung sama mapnya
	$Level/Player/Camera2D.limit_bottom = 1035
	$Level/Player/Camera2D.limit_top = -575
	$Level/Player/Camera2D.limit_left = -900
	$Level/Player/Camera2D.limit_right = 1770

func spawnEnemy(delta):
	if spawnCD > 5:
		if spawnDelay>1 and (GlobalVariables.enemySpawned<GlobalVariables.waveEnemyCount or GlobalVariables.bossPhase):
			$Level/Spawner1.spawnEnemy()
			$Level/Spawner2.spawnEnemy()
			$Level/Spawner3.spawnEnemy()
			$Level/Spawner4.spawnEnemy()
			spawnDelay = 0
		else:
			spawnDelay += delta
	else:
		spawnCD += delta

func spawnNPC(delta):
	if GlobalVariables.npcExists == false:
		if npcSpawnDelay > 5:
			var randomChance = rand_range(0,100)
			if randomChance<25:
				if $Level/NPCSpawner1.onCamera==false:
					$Level/NPCSpawner1.spawnNPC()
					GlobalVariables.npcExists = true
					npcSpawnDelay = 0
			elif randomChance<50:
				if $Level/NPCSpawner2.onCamera==false:
					$Level/NPCSpawner2.spawnNPC()
					GlobalVariables.npcExists = true
					npcSpawnDelay = 0
			elif randomChance<75:
				if $Level/NPCSpawner3.onCamera==false:
					$Level/NPCSpawner3.spawnNPC()
					GlobalVariables.npcExists = true
					npcSpawnDelay = 0
			else:
				if $Level/NPCSpawner4.onCamera==false:
					$Level/NPCSpawner4.spawnNPC()
					GlobalVariables.npcExists = true
					npcSpawnDelay = 0
		else:
			npcSpawnDelay += delta
			

func doBossPhase(delta):
	if spawnCD > 5:
		if !bossSpawned:
			if GlobalVariables.waveCount > 40:
				$Level/bossSpawner.spawnBoss3() 
			elif GlobalVariables.waveCount > 20:
				$Level/bossSpawner.spawnBoss2()
			else:
				$Level/bossSpawner.spawnBoss()
			bossSpawned = true
		
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
			if GlobalVariables.waveCount%20==0:
				get_tree().change_scene("res://Scenes - Map/Map - Pelabuhan.tscn")
			else:
				get_tree().change_scene("res://Scenes - Map/Map - Perkotaan.tscn")
		GlobalVariables.npcExists = false
	else:
		if spawnCD>4:
			$GUI.playChangeMap()
			$Audio/BGM.stop()
			$Audio/BGM_boss.stop()
		spawnCD+=delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !mapFinished:
		if GlobalVariables.bossPhase == false:
			if waveFinished:
				spawnCD = 0
				waveFinished = false
			else:
				spawnEnemy(delta)
				if GlobalVariables.enemySpawned>=GlobalVariables.waveEnemyCount:
					if GlobalVariables.currentEnemyCount <= 0:
						waveFinished = true
						#get_node("Level/Player").playerHealth = GlobalVariables.playerMaxHealth
						GlobalVariables.waveCount += 1
						GlobalVariables.waveEnemyCount = 10 + GlobalVariables.waveCount*5
						GlobalVariables.enemySpawned = 0
						if GlobalVariables.waveCount%5==0:
							if GlobalVariables.waveCount%20==0:
								changeMap(delta)
							else:
								GlobalVariables.bossPhase = true
								$Audio/BGM.stop()
								$Audio/BGM_boss.play()
								bossSpawned = false
						spawnCD = 0
						
						$GUI/WaveClear.visible = true
						$GUI/WaveClear.frame = 0
						$GUI/WaveClear.play()
						
						$Audio/WaveClear.play()
			
		else:
			doBossPhase(delta)
	else:
		changeMap(delta)
	
	if GlobalVariables.currentEnemyCount > 10 or GlobalVariables.bossPhase:
		spawnNPC(delta)



func _on_BGM_finished():
	if GlobalVariables.waveCount%5!=0:
		$Audio/BGM.play()
	pass # Replace with function body.


func _on_BGM_boss_finished():
	if GlobalVariables.waveCount%5==0:
		$Audio/BGM_boss.play()
	pass # Replace with function body.
