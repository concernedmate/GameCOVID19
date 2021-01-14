extends KinematicBody2D

#Notes: collision bit 19 reserved buat peluru slime ini 
#       saja setidaknya buat peluru ini saja di satu 
#       scene jadi mungkin bisa digunakan di bos lain

# Declare member variables here. Examples:
var health = 3000
var healthBar

var horn_R_origin = Vector2(150, -30) #posisi original
var horn_L_origin = Vector2(-150, -30)
const hornAttackSpd = 2000
const hornSpeed = 250
var hornRinPosition = false #true bila sudah selesai menyerang dan otw balik ke posisi origin
var hornLinPosition = false

#attack
var combo = 0 #menentukan jenis serangan (horn)
var shootTimer = 0
var shootCD = 0.5
var bulletType = 3 #menentukan jenis serangan (bullet)
var bulletRot = 30
var bulletRotDirection = 1
var slimeCount = 0 #jumlah setiap spit
var slimeMax = 1 #maksimum setiap spit
var spitTimer = 0
var canSpit = false
var canSlam = false
var canUlt = false
var target = Vector2(650 , 380)
const targetDefault = Vector2(650 , 380)

const VIRUS_BULLET = preload("res://Scenes - Projectile/peluruSerpentes.tscn")    
const VIRUS_SLIME = preload("res://Scenes - Projectile/peluruSerpentesLedak.tscn")
const HP_BAR = preload("res://Scenes - Map/HPBARBOSS.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Horn_L.target = horn_L_origin
	$Horn_R.target = horn_R_origin
	$Horn_L.speed = hornSpeed
	$Horn_R.speed = hornSpeed
	randomize()
	healthBar = HP_BAR.instance()
	get_node("/root/Root/GUI/Container_BossHP").add_child(healthBar)
	healthBar.max_value = 3000
	healthBar.changeText("Parientela      Viperolous")
	GlobalVariables.bossAlive += 1
	GlobalVariables.bossPhaseSpawnCreep = true
	GlobalVariables.bossPhase = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	healthBar.value = health
	#phase 1
	if health>2500:
		canSpit = false
		bulletType = 0
	#phase 2
	elif health > 1500:
		canSlam = true
		bulletType = 1
	#phase 3
	elif health > 500:
		bulletType = 2
		canSpit = true
		canUlt = true
	#phase 4
	elif health > 250:
		bulletType = 3
		canSpit = true
		canUlt = true
	
	if health>0:
		if (get_tree().get_nodes_in_group("slimes").size()>=4):
			get_tree().call_group("slimes", "explode")
			spitTimer = 0
		
		if spitTimer>5 and canSpit:
			_spit(delta)
		else:
			spitTimer+=delta
		
		_shoot(delta, bulletType)
		if bulletType!=3 and canSlam:
			if (hornLinPosition and hornRinPosition):
				_hornReturnR()
				_hornReturnL()
			else:
				_hornThrustL()
				_hornThrustR()
		else:
				_hornReturnR()
				_hornReturnL()
	else:
		GlobalVariables.bossAlive -= 1
		GlobalVariables.Score += 10000
		queue_free()

func _hornThrustL():
	if ($Horn_L.position.y<(horn_L_origin.y + 200)):
		$Horn_L.speed = hornAttackSpd
		$Horn_L.target = horn_L_origin + Vector2(0, 200)
		$Horn_L.attacking = true
	else:
		hornLinPosition = true

func _hornThrustR():
	if ($Horn_R.position.y<(horn_R_origin.y + 200)):
		$Horn_R.speed = hornAttackSpd
		$Horn_R.target = horn_R_origin + Vector2(0, 200)
		$Horn_R.attacking = true
	else:
		hornRinPosition = true

func _hornReturnL():
	$Horn_L.speed = hornSpeed
	$Horn_L.target = horn_L_origin
	$Horn_L.attacking = false
	if ($Horn_L.position == horn_L_origin):
		hornLinPosition = false

func _hornReturnR():
	$Horn_R.speed = hornSpeed
	$Horn_R.target = horn_R_origin
	$Horn_R.attacking = false
	if ($Horn_R.position == horn_R_origin):
		hornRinPosition = false

func _roar():
	pass

func _spit(delta):
	$AnimatedSprite.animation = "spit"
	if $AnimatedSprite.frame == 3:
		if slimeCount<slimeMax:
			var slime1 = VIRUS_SLIME.instance()
			var slime2 = VIRUS_SLIME.instance()
			slime1.firstVelocity = Vector2(500, 10)
			slime2.firstVelocity = Vector2(-500, 10)
			slime1.position = position + Vector2(200,-20)
			slime2.position = position + Vector2(-200,-20)
			get_parent().add_child(slime1)
			get_parent().add_child(slime2)
			slimeCount+=1
	if $AnimatedSprite.frame == 4:
		slimeCount = 0
		spitTimer = 0

func _shoot(delta, type):
	match type:
		0: #3 bullet muter
			shootCD = 0.25
			if shootTimer > shootCD:
				var bullet1 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet1)            #make the new node as child of root
				bullet1.position = position - Vector2(0, 50)
				bullet1.originalPos = position - Vector2(0, 50)
				bullet1.target = target.rotated(deg2rad(bulletRot))
				
				var bullet2 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet2)            #make the new node as child of root
				bullet2.position = position - Vector2(0, 50)
				bullet2.originalPos = position - Vector2(0, 50)
				bullet2.target = target.rotated(deg2rad(bulletRot)+2)
				
				var bullet3 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet3)            #make the new node as child of root
				bullet3.position = position - Vector2(0, 50)
				bullet3.originalPos = position - Vector2(0, 50)
				bullet3.target = target.rotated(deg2rad(bulletRot)-2)
				
				if bulletRot==330:
					bulletRot = 0
				else:
					bulletRot += 30
				
				shootTimer = 0
			else:
				shootTimer+=delta
		1: #6 bullet
			shootCD = 0.25
			if shootTimer > shootCD:
				var bullet1 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet1)            #make the new node as child of root
				bullet1.position = position - Vector2(0, 50)
				bullet1.originalPos = position - Vector2(0, 50)
				bullet1.target = target.rotated(deg2rad(bulletRot))
				
				var bullet2 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet2)            #make the new node as child of root
				bullet2.position = position - Vector2(0, 50)
				bullet2.originalPos = position - Vector2(0, 50)
				bullet2.target = target.rotated(deg2rad(bulletRot)+1)
				
				var bullet3 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet3)            #make the new node as child of root
				bullet3.position = position - Vector2(0, 50)
				bullet3.originalPos = position - Vector2(0, 50)
				bullet3.target = target.rotated(deg2rad(bulletRot)+2)
				
				var bullet4 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet4)            #make the new node as child of root
				bullet4.position = position - Vector2(0, 50)
				bullet4.originalPos = position - Vector2(0, 50)
				bullet4.target = target.rotated(deg2rad(bulletRot)+3)
				
				var bullet5 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet5)            #make the new node as child of root
				bullet5.position = position - Vector2(0, 50)
				bullet5.originalPos = position - Vector2(0, 50)
				bullet5.target = target.rotated(deg2rad(bulletRot)+4)
				
				var bullet6 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet6)            #make the new node as child of root
				bullet6.position = position - Vector2(0, 50)
				bullet6.originalPos = position - Vector2(0, 50)
				bullet6.target = target.rotated(deg2rad(bulletRot)+5)
				
				if bulletRot==330:
					bulletRot = 0
				else:
					bulletRot += 30
				
				shootTimer = 0
			else:
				shootTimer+=delta
		2: #6 bullet faster
			shootCD = 0.15
			if shootTimer > shootCD:
				var bullet1 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet1)            #make the new node as child of root
				bullet1.position = position - Vector2(0, 50)
				bullet1.originalPos = position - Vector2(0, 50)
				bullet1.target = target.rotated(deg2rad(bulletRot))
				
				var bullet2 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet2)            #make the new node as child of root
				bullet2.position = position - Vector2(0, 50)
				bullet2.originalPos = position - Vector2(0, 50)
				bullet2.target = target.rotated(deg2rad(bulletRot)+1)
				
				var bullet3 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet3)            #make the new node as child of root
				bullet3.position = position - Vector2(0, 50)
				bullet3.originalPos = position - Vector2(0, 50)
				bullet3.target = target.rotated(deg2rad(bulletRot)+2)
				
				var bullet4 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet4)            #make the new node as child of root
				bullet4.position = position - Vector2(0, 50)
				bullet4.originalPos = position - Vector2(0, 50)
				bullet4.target = target.rotated(deg2rad(bulletRot)+3)
				
				var bullet5 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet5)            #make the new node as child of root
				bullet5.position = position - Vector2(0, 50)
				bullet5.originalPos = position - Vector2(0, 50)
				bullet5.target = target.rotated(deg2rad(bulletRot)+4)
				
				var bullet6 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet6)            #make the new node as child of root
				bullet6.position = position - Vector2(0, 50)
				bullet6.originalPos = position - Vector2(0, 50)
				bullet6.target = target.rotated(deg2rad(bulletRot)+5)
				
				if bulletRot==330:
					bulletRot = 0
				else:
					bulletRot += 30
				
				shootTimer = 0
			else:
				shootTimer+=delta
		3: #9 bullet fastest
			shootCD = 0.125
			if shootTimer > shootCD:
				var bullet1 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet1)            #make the new node as child of root
				bullet1.position = position - Vector2(0, 50)
				bullet1.originalPos = position - Vector2(0, 50)
				bullet1.target = target.rotated(deg2rad(bulletRot))
				
				var bullet2 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet2)            #make the new node as child of root
				bullet2.position = position - Vector2(0, 50)
				bullet2.originalPos = position - Vector2(0, 50)
				bullet2.target = target.rotated(deg2rad(bulletRot)+1.5)
				
				var bullet3 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet3)            #make the new node as child of root
				bullet3.position = position - Vector2(0, 50)
				bullet3.originalPos = position - Vector2(0, 50)
				bullet3.target = target.rotated(deg2rad(bulletRot)+3)
				
				var bullet4 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet4)            #make the new node as child of root
				bullet4.position = position - Vector2(0, 50)
				bullet4.originalPos = position - Vector2(0, 50)
				bullet4.target = target.rotated(deg2rad(bulletRot)+4.5)
				
				var bullet5 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet5)            #make the new node as child of root
				bullet5.position = position - Vector2(0, 50)
				bullet5.originalPos = position - Vector2(0, 50)
				bullet5.target = target.rotated(deg2rad(bulletRot)+0.75)
				
				var bullet6 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet6)            #make the new node as child of root
				bullet6.position = position - Vector2(0, 50)
				bullet6.originalPos = position - Vector2(0, 50)
				bullet6.target = target.rotated(deg2rad(bulletRot)+2.25)
				
				var bullet7 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet7)            #make the new node as child of root
				bullet7.position = position - Vector2(0, 50)
				bullet7.originalPos = position - Vector2(0, 50)
				bullet7.target = target.rotated(deg2rad(bulletRot)+3.75)
				
				var bullet8 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet8)            #make the new node as child of root
				bullet8.position = position - Vector2(0, 50)
				bullet8.originalPos = position - Vector2(0, 50)
				bullet8.target = target.rotated(deg2rad(bulletRot)+5.25)
				
				var bullet9 = VIRUS_BULLET.instance()       #create new node
				get_parent().get_parent().add_child(bullet9)            #make the new node as child of root
				bullet9.position = position - Vector2(0, 50)
				bullet9.originalPos = position - Vector2(0, 50)
				bullet9.target = target.rotated(deg2rad(bulletRot)+6)
				
				if bulletRot==330:
					bulletRot = 0
				else:
					bulletRot += 30
				
				shootTimer = 0
			else:
				shootTimer+=delta


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.animation = "idle"
