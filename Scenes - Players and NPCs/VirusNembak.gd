extends KinematicBody2D

const VIRUS_BULLET = preload("res://Scenes - Projectile/peluruVirus.tscn")    #fireball
var target
var targetAcquired = false
var health = 4
const speed = 75
const attackRange = 400
var velocity
var enemyTarget
var cooldown = 1
var currentCombo = 0
var maxCombo = 3

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
#func _process(delta):
#	pass
func _physics_process(delta):
	#print(health)
	if target.x>position.x:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	if health>0:
		if cooldown<=0:
			if enemyTarget == null:
				idle()
			else:
				chase()
		else:
			cooldown -= delta
		#attack()
	else:
		#todo start dying animation
		GlobalVariables.currentEnemyCount -= 1
		dropPickup()
		GlobalVariables.Score += 15 * GlobalVariables.ScoreMult
		var blood = FX_BLOOD_DEATH.instance()
		get_parent().add_child(blood)
		blood.position = position
		blood.modulate = Color(0, 0.7, 0)
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
func chase():
	if (enemyTarget.position-position).length()<attackRange:
		attack()
	else:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "idle"
		#no pathfinding yet, just simple move x,y to x,y
		velocity = (enemyTarget.position-position).normalized() * speed
		velocity = move_and_slide(velocity)
		if enemyTarget.position.x>position.x:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
	
func attack():
	target = enemyTarget.position
	$AnimatedSprite.animation = "nembak"
	$AnimatedSprite.play()
	if ($AnimatedSprite.frame == 6):
		#shoot
		var bullet = VIRUS_BULLET.instance()       #create new node
		get_parent().add_child(bullet)            #make the new node as child of root
		bullet.position = position + (target - position).normalized() * 25
		bullet.originalPos = position + (target - position).normalized() * 25
		bullet.target = target - position
		$AnimatedSprite.frame = 7
		$AnimatedSprite.stop()
		currentCombo+=1
		if currentCombo>=maxCombo:
			cooldown = 1
			currentCombo = 0




func _on_DetectionArea_body_entered(body):
	if "team" in body:
		if body.team != 1:
			enemyTarget = body
	pass # Replace with function body.


