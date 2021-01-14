extends Node

#mainmenustuff
var inMainMenu = false

# Declare member variables here. Examples:
var Score = 0
var waveCount = 1 #sekarang wave ke berapa
var waveEnemyCount = 15 #jumlah musuh yg akan di spawn
var currentEnemyCount = 0 #jumlah musuh skrg (yg sudah mati tidak dihitung)
var enemySpawned = 0 #jumlah musuh yang sudah di spawn

var npcExists = false
var npcPosition = Vector2(0, 0) #tempat npc yg perlu diselamatkan

#player stuff
var playerMaxHealth = 20
var playerBombs = 3
var tutorialFinished = false
#persistent stuff
#items
var hasLife = false

#skills
var skillBlasty1
var skillBlasty2
var skillGeni1
var skillGeni2
var skillSegara1
var skillSegara2

#upgrade


var bossPhase = false #Special wave phase untuk boss
var bossPhaseSpawnCreep = true #swithc untuk enable/disable creepspawn pas bossPhase
var bossAlive = 0
var areaBossEnemy = 0 #tipe precil yg keluar, 0 taman, 1 kota, 2 perumahan

#powerup stuff
var ScoreMult = 1.0
var playerHasteMult = 1.0 #mult kecepatan haste
var invincible = false
var doubleDamageMult = 1.0

func reset():
	Score = 0
	waveCount = 1 #sekarang wave ke berapa
	waveEnemyCount = 15 #jumlah musuh yg akan di spawn
	currentEnemyCount = 0 #jumlah musuh skrg (yg sudah mati tidak dihitung)
	enemySpawned = 0 #jumlah musuh yang sudah di spawn
	
	npcExists = false
	npcPosition = Vector2(0, 0)
	
	playerMaxHealth = 20
	playerBombs = 3
	
	bossPhase = false #Special wave phase untuk boss
	bossPhaseSpawnCreep = true #swithc untuk enable/disable creepspawn pas bossPhase
	bossAlive = 0
	areaBossEnemy = 0 #tipe precil yg keluar, 0 taman, 1 kota, 2 perumahan
	
	#powerup stuff
	ScoreMult = 1.0
	playerHasteMult = 1.0 #mult kecepatan haste
	invincible = false
	doubleDamageMult = 1.0

