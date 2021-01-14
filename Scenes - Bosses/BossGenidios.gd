extends KinematicBody2D

var target
var targetAcquired = false
var health = 1750
var healthBar
var speed = 200
var attackRange = 400
var velocity
var enemyTarget #player
var predictionJarak = 250 #150 pretty hard, jarak predict gerakan player
var besarLedakan = 1.0 #besar ledakan, tak bikin cuma mempengaruhi ledakan awal/tengah

var bombSpawned = false
var attacking = false
var attackTimer = 0
var attackCD = 3
var currentCombo = 0
var combo = 2
var canSpawn = false
var spawnCount = 0
var maxSpawnCount = 2
var ulted = false
var ring

const FX_BLOOD_DEATHBOSS = preload("res://Scenes - FX/bloodFX_bossdeath.tscn")

const HP_BAR = preload("res://Scenes - Map/HPBARBOSS.tscn")
const FX_ROAR = preload("res://Scenes - FX/roarEffect.tscn")
const SPAWN_DYNA = preload("res://Scenes - Players and NPCs/VirusLedak.tscn")
const SPAWN_FIRE = preload("res://Scenes - Projectile/Boss_RingGenidios.tscn")
const ORB_EXPLOSION1 = preload("res://Scenes - Projectile/ledakanGenidios1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	healthBar = HP_BAR.instance()
	get_node("/root/Root/GUI/Container_BossHP").add_child(healthBar)
	healthBar.max_value = 1750
	healthBar.changeText("Genidios")
	GlobalVariables.bossAlive += 1
	GlobalVariables.bossPhaseSpawnCreep = true
	enemyTarget = get_node("/root/Root/Level/Player") 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	healthBar.value = health
	if health <= 500:
		if speed!=0:
			speed = 400
		attackRange = 1500
		maxSpawnCount = 6
		combo = 5
		attackCD = 1.75
		$AnimatedSprite.speed_scale = 1.35
	elif health <= 1000:
		speed = 300
		combo = 3
		maxSpawnCount = 4
		attackCD = 2.5
		$AnimatedSprite.speed_scale = 1.15
	elif health <= 1500:
		canSpawn = true

	if health>0:
		idle(delta)
	else:
		#todo start dying animation
		GlobalVariables.bossAlive -= 1
		GlobalVariables.Score += 5000
		if ring!=null:
			ring.queue_free()
		var blood = FX_BLOOD_DEATHBOSS.instance()
		get_parent().add_child(blood)
		blood.position = position
		blood.modulate = Color(0.7, 0, 0)
		blood.one_shot = true
		queue_free()

func idle(delta):
	if health<=500 and !ulted:
		walkToMiddle(delta)
	else:
		if attackTimer<attackCD:
			$AnimatedSprite.animation = "idle"
			$AnimatedSprite.play()
			attackTimer += delta
		else:
			if currentCombo != combo:
				chase(delta)
			else:
				spawnPrecil(delta)

#implement pathfinding
func chase(delta):
	#harus sesuai pathnya
	if (enemyTarget.position-position).length()<attackRange or attacking:
			attacking = true
			attack(delta)
	else:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "idle"
		#no pathfinding yet, just simple move x,y to x,y
		velocity = (enemyTarget.position-position).normalized() * speed
		velocity = move_and_slide(velocity)
	
func attack(delta):
	$AnimatedSprite.animation = "attack"
	$AnimatedSprite.play()
	if $AnimatedSprite.frame == 4 and bombSpawned == false:
		if $slam.playing ==false:
			$slam.play()
		#spawn firewall
		var explosion = ORB_EXPLOSION1.instance()
		explosion.position = enemyTarget.position - Vector2(0, 70)
		if Input.is_action_pressed("ui_right"):
			var explosion2 = ORB_EXPLOSION1.instance()
			explosion2.position = enemyTarget.position - Vector2(0, 70)
			explosion2.position += Vector2(predictionJarak, 0)
			get_parent().add_child(explosion2)
		if Input.is_action_pressed("ui_left"):
			var explosion2 = ORB_EXPLOSION1.instance()
			explosion2.position = enemyTarget.position - Vector2(0, 70)
			explosion2.position += Vector2(-predictionJarak, 0)
			get_parent().add_child(explosion2)
		if Input.is_action_pressed("ui_down"):
			var explosion2 = ORB_EXPLOSION1.instance()
			explosion2.position = enemyTarget.position - Vector2(0, 70)
			explosion2.position += Vector2(0, predictionJarak)
			get_parent().add_child(explosion2)
		if Input.is_action_pressed("ui_up"):
			var explosion2 = ORB_EXPLOSION1.instance()
			explosion2.position = enemyTarget.position - Vector2(0, 70)
			explosion2.position += Vector2(0, -predictionJarak)
			get_parent().add_child(explosion2)
		explosion.scale.x = besarLedakan
		explosion.scale.y = besarLedakan
		get_parent().add_child(explosion)
		bombSpawned = true
		#currentCombo += 1
	
	if $AnimatedSprite.frame == 6:
		if bombSpawned:
			currentCombo += 1
		bombSpawned = false
		attacking = false
		if currentCombo >= combo:
			if !canSpawn:
				currentCombo = 0
				attackTimer = 0
	#TODO EXPLOSION

func spawnPrecil(delta):
	$AnimatedSprite.animation = "spawn"
	$AnimatedSprite.play()
	if $AnimatedSprite.frame == 3:
		if $spawn.playing==false:
			$spawn.play()
		if spawnCount<maxSpawnCount:
			var dyna = SPAWN_DYNA.instance()
			dyna.naturalSpawn = false
			dyna.position = position + Vector2(-60, 80)
			get_parent().add_child(dyna)
			spawnCount += 1
	
	if $AnimatedSprite.frame == 6:
		currentCombo = 0
		attackTimer = 0
		bombSpawned = false
		spawnCount = 0

func walkToMiddle(delta):
	if (get_node("/root/Root/Level/bossSpawner").position-position).length()>25:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "idle"
		#no pathfinding yet, just simple move x,y to x,y
		velocity = (get_node("/root/Root/Level/bossSpawner").position-position).normalized() * speed
		velocity = move_and_slide(velocity)
	else:
		position = get_node("/root/Root/Level/bossSpawner").position
		spawnUlt(delta)
		
func spawnUlt(delta):
	#sementara
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "attack"
	if $AnimatedSprite.frame == 6:
		speed = 0
		if ring==null:
			ring = SPAWN_FIRE.instance()
			ring.position = position #offsetnya dikarenakan Ysort
			get_parent().get_parent().add_child(ring)
			if $roar.playing == false:
				$roar.play()
			var roarFX = FX_ROAR.instance()
			get_parent().add_child(roarFX)
			roarFX.position = position + Vector2(0, -16)
		ulted = true
		GlobalVariables.bossPhaseSpawnCreep = false
