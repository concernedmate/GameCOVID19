extends KinematicBody2D


# Declare member variables here. Examples:
var target
var targetAcquired = false
var health = 1500
var healthBar
var speed = 200
const attackRange = 300
var velocity
var enemyTarget
var enemyPosition 
var flying = ""

var charge = 0
var attacking = false
var attackTimer
var attackCD = 2
var maxCombo = 2
var currentCombo = 0

var laser
var laserRotateSwitch = 1

var laserMuter
var laserMuterKotak1
var laserMuterKotak2
var laserMuterKotak3
var laserMuterKotak4
var bigBeam
var muterTimer = 25

var doFastMuter = false
var doMuter = false
var canSpit = false
var laserSpeedMult = 1.0


const FX_BLOOD_DEATHBOSS = preload("res://Scenes - FX/bloodFX_bossdeath.tscn")

const HP_BAR = preload("res://Scenes - Map/HPBARBOSS.tscn")
const FX_ROAR = preload("res://Scenes - FX/roarEffect.tscn")
const ORB_LASER_BEAM = preload("res://Scenes - Projectile/Boss_LaserSegaradios.tscn")
const ORB_BIG_BEAM = preload("res://Scenes - Projectile/Boss_BigLaserSegaradios.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	healthBar = HP_BAR.instance()
	get_node("/root/Root/GUI/Container_BossHP").add_child(healthBar)
	healthBar.max_value = 1500
	healthBar.changeText("Segaradios")
	GlobalVariables.bossAlive += 1
	GlobalVariables.bossPhaseSpawnCreep = true
	enemyTarget = get_node("/root/Root/Level/Player") 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	healthBar.value = health
	if $roar_enraged.playing:
		$roar_enraged.pitch_scale += 1.0*delta
		$roar_enraged.volume_db += 10*delta
	if health<1350:
		if flying == "":
			var new_parent = get_node("/root/Root")
			get_parent().remove_child(self)
			new_parent.add_child(self)
			flying = "_fly"
			speed = 450
			doMuter = true
		set_collision_mask_bit(4, false)  #disable collision
		set_collision_layer_bit(4, false) #disable collision
	if health < 1000:
		doFastMuter = true
		canSpit = true
		laserSpeedMult = 1.15
	if health < 750:
		maxCombo = 1
		laserSpeedMult = 1.25
		
	if health>0:
		chase(delta)
	else:
		#todo start dying animation
		GlobalVariables.bossAlive -= 1
		GlobalVariables.Score += 5000
		if is_instance_valid(laser):
			laser.timer = laser.lifetime
		if is_instance_valid(laserMuterKotak1):
			laserMuterKotak1.timer = laserMuterKotak1.lifetime
			laserMuterKotak2.timer = laserMuterKotak2.lifetime
			laserMuterKotak3.timer = laserMuterKotak3.lifetime
			laserMuterKotak4.timer = laserMuterKotak4.lifetime
		if is_instance_valid(laserMuter):
			laserMuter.timer = laserMuter.lifetime
		if is_instance_valid(bigBeam):
			bigBeam.timer = bigBeam.lifetime
		var blood = FX_BLOOD_DEATHBOSS.instance()
		get_parent().add_child(blood)
		blood.position = position
		blood.modulate = Color(0, 0, 0.7)
		blood.one_shot = true
		queue_free()
		

func idle(delta):
	if attackTimer<attackCD:
		$AnimatedSprite.animation = "idle" + flying
		$AnimatedSprite.play()
		attackTimer += delta
	else:
		chase(delta)

#implement pathfinding
func chase(delta):
	#harus sesuai pathnya
	if (enemyTarget.position-position).length()<attackRange or attacking:
		attacking = true
		if !is_instance_valid(laserMuterKotak1) and doMuter:
			attackMuter(delta)
		else:
			if !is_instance_valid(laserMuter) and doFastMuter:
				attackMuterSingle(delta)
			else:
				if currentCombo>maxCombo and canSpit:
					spit(delta)
				else:
					attack(delta)
	else:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "idle" + flying
		#no pathfinding yet, just simple move x,y to x,y
		if is_instance_valid(laser):
			laser.position = position + Vector2(0, -40)
		if is_instance_valid(laserMuterKotak1):
			laserMuterKotak1.position = position + Vector2(0, -40)
			laserMuterKotak2.position = position + Vector2(0, -40)
			laserMuterKotak3.position = position + Vector2(0, -40)
			laserMuterKotak4.position = position + Vector2(0, -40)
		if is_instance_valid(laserMuter):
			laserMuter.position = position + Vector2(0, -40)
		velocity = (enemyTarget.position-position).normalized() * speed
		velocity = move_and_slide(velocity)

func attack(delta):
	if charge>1:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "laser" + flying
		if !is_instance_valid(laser):
			laser = ORB_LASER_BEAM.instance()
			get_parent().add_child(laser)
			laser.position = position + Vector2(0, -40)
			laser.target = enemyTarget.position - position
			laser.rotate_speed = 0.7 * laserSpeedMult * laserRotateSwitch
			laser.rotation_degrees = -45 * laserRotateSwitch
			laser.lifetime = attackCD
			laser.slowDown = 0.35
			laserRotateSwitch = laserRotateSwitch * -1
			if flying == "_fly":
				laser.tembus = true
		if $AnimatedSprite.frame == 4:
			charge = 0
			currentCombo +=1
			attacking = false
			attackTimer = 0
	else:
		charging(delta)

func attackMuter(delta):
	if charge>3:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "laser" + flying
		if !is_instance_valid(laserMuterKotak1):
			var roarFX = FX_ROAR.instance()
			get_parent().add_child(roarFX)
			roarFX.position = position + Vector2(0, -40)
			if !$roar_enraged.playing:
				$roar_enraged.pitch_scale = 2.0
				$roar_enraged.play()
				$roar_enraged.volume_db = -15
			laserMuterKotak1 = ORB_LASER_BEAM.instance()
			laserMuterKotak2 = ORB_LASER_BEAM.instance()
			laserMuterKotak3 = ORB_LASER_BEAM.instance()
			laserMuterKotak4 = ORB_LASER_BEAM.instance()
			get_parent().add_child(laserMuterKotak1)
			get_parent().add_child(laserMuterKotak2)
			get_parent().add_child(laserMuterKotak3)
			get_parent().add_child(laserMuterKotak4)
			laserMuterKotak1.target = Vector2(0, 1)
			laserMuterKotak2.target = Vector2(0, -1)
			laserMuterKotak3.target = Vector2(1, 0)
			laserMuterKotak4.target = Vector2(-1, 0)
			laserMuterKotak1.rotate_speed = 0.5 * laserSpeedMult
			laserMuterKotak2.rotate_speed = 0.5 * laserSpeedMult
			laserMuterKotak3.rotate_speed = 0.5 * laserSpeedMult
			laserMuterKotak4.rotate_speed = 0.5 * laserSpeedMult
			laserMuterKotak1.position = position + Vector2(0, -40)
			laserMuterKotak2.position = position + Vector2(0, -40)
			laserMuterKotak3.position = position + Vector2(0, -40)
			laserMuterKotak4.position = position + Vector2(0, -40)
			laserMuterKotak1.lifetime = muterTimer
			laserMuterKotak2.lifetime = muterTimer
			laserMuterKotak3.lifetime = muterTimer
			laserMuterKotak4.lifetime = muterTimer
			if flying == "_fly":
				laserMuterKotak1.tembus = true
				laserMuterKotak2.tembus = true
				laserMuterKotak3.tembus = true
				laserMuterKotak4.tembus = true
		charge = 0
		attacking = false
		attackTimer = 0
	else:
		chargingBig(delta)

func attackMuterSingle(delta):
	if charge > 2:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "laser" + flying
		if !is_instance_valid(laserMuter):
			laserMuter = ORB_LASER_BEAM.instance()
			get_parent().add_child(laserMuter)
			laserMuter.target = Vector2(0, -1)
			if enemyTarget.position.x>position.x:
				laserMuter.rotate_speed = 1.0 * laserSpeedMult 
			else:
				laserMuter.rotate_speed = -1.0 * laserSpeedMult 
			laserMuter.position = position + Vector2(0, -40)
			laserMuter.lifetime = muterTimer
			if flying == "_fly":
				laserMuter.tembus = true
		charge = 0
		attacking = false
		attackTimer = 0
	else:
		chargingBig(delta)

func spit(delta):
	if charge>1:
		if charge>1.5:
			$AnimatedSprite.play()
			$AnimatedSprite.animation = "spit" + flying
			if $AnimatedSprite.frame == 4:
				if !is_instance_valid(bigBeam):
					bigBeam = ORB_BIG_BEAM.instance()
					get_parent().add_child(bigBeam)
					bigBeam.target = Vector2(1, 0)
					bigBeam.position = enemyTarget.position + Vector2(-1000, 0)
				charge = 0
				attacking = false
				attackTimer = 0
				currentCombo = 0
		else:
			chargingBig(delta)
	else:
		charging(delta)

func charging(delta):
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "charge" + flying
	charge+=delta
	
func chargingBig(delta):
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "charge2" + flying
	charge+=delta
