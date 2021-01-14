extends KinematicBody2D

const VIRUS_LASER = preload("res://Scenes - Projectile/LaserBeam.tscn")
var target
var laserTarget
var targetAcquired = false
var health = 12
const speed = 75
const attackRange = 300
var velocity
var bullet
var enemyTarget
var cooldown = 3
var timer = 0  #waktu sebelum spawn laser
var attacking = false

#team
var team = 1

const FX_BLOOD_DEATH = preload("res://Scenes - FX/bloodFX_death.tscn")

#load pickup scene
const PICKUP_ARMOR = preload("res://Scenes - Pickups/armorPickup.tscn")
const PICKUP_HEALTH = preload("res://Scenes - Pickups/healthPickup.tscn")
const PICKUP_SCORE = preload("res://Scenes - Pickups/scorePickup.tscn")
const PICKUP_DD = preload("res://Scenes - Pickups/ddPickup.tscn")
const PICKUP_INV = preload("res://Scenes - Pickups/inviPickup.tscn")
const PICKUP_HASTE = preload("res://Scenes - Pickups/hastePickup.tscn")
const PICKUP_BOMB = preload("res://Scenes - Pickups/bombPickup.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	target = position
	randomize()  #needed for rand_range
	pass # Replace with function body.

func dropPickup():
	var chance = rand_range(0,100)
	if chance<10:
		var pickup = PICKUP_HEALTH.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	elif chance<15:
		var pickup = PICKUP_ARMOR.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	elif chance<17:
		var pickup = PICKUP_SCORE.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	elif chance<18:
		var pickup = PICKUP_DD.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	elif chance<19:
		var pickup = PICKUP_HASTE.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	elif chance<20:
		var pickup = PICKUP_INV.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	elif chance<22:
		var pickup = PICKUP_BOMB.instance()
		get_parent().add_child(pickup)
		pickup.position = position
	else:
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if health>0:
		if cooldown<=0:
			if enemyTarget == null:
				idle()
			else:
				chase(delta)
		else:
			cooldown -= delta
		#attack()
	else:
		#todo start dying animation
		if is_instance_valid(bullet):
			bullet.timer = 2.0
		GlobalVariables.currentEnemyCount -= 1
		dropPickup()
		GlobalVariables.Score += 35 * GlobalVariables.ScoreMult
		var blood = FX_BLOOD_DEATH.instance()
		get_parent().add_child(blood)
		blood.position = position
		blood.modulate = Color(0, 0.9, 1)
		blood.one_shot = true
		queue_free()

	

func idle():
	#bbrp baris mungkin gaguna belum tak ubahi lg dari kodingan proyekku afif
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "idle"
	#action = idle
	if (targetAcquired==false):
		target = position + (Vector2(rand_range(-200,200), rand_range(-200,200))*2)
		targetAcquired = true
	else:
		if ((target - position).length() > 10):
			velocity = (target-position).normalized() * speed
			velocity = move_and_slide(velocity)
			if (is_on_wall()):
				targetAcquired = false
		else:
			cooldown = 0.5
			$AnimatedSprite.frame = 0
			$AnimatedSprite.stop()
			targetAcquired = false

#implement pathfinding
func chase(delta):
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
	laserTarget = enemyTarget.position
	$AnimatedSprite.animation = "idleRed"
	$AnimatedSprite.play()
	if (timer >= 0.4):
		#shoot
		bullet = VIRUS_LASER.instance()       #create new node
		get_parent().add_child(bullet)            #make the new node as child of root
		bullet.position = position + Vector2(1,1)
		bullet.target = laserTarget - position
		$AnimatedSprite.animation = "idle"
		attacking = false
		timer = 0
		cooldown = 3
	elif timer<0.4:
		timer+=delta




func _on_DetectionArea_body_entered(body):
	if "team" in body:
		if body.team != 1:
			enemyTarget = body
	pass # Replace with function body.


