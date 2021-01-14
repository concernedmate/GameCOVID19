extends KinematicBody2D

var target
var targetAcquired = false
var health = 4
const speed = 200
const attackRange = 50
var velocity
var enemyTarget
var attacking = false
var attackCD = 0
var bitten = false
#team
var team = 1

#load FX
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
	randomize()
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
	if health>0:
		chase(delta)
	else:
		#todo start dying animation
		GlobalVariables.currentEnemyCount -= 1
		dropPickup()
		GlobalVariables.Score += 10 * GlobalVariables.ScoreMult
		var blood = FX_BLOOD_DEATH.instance()
		get_parent().add_child(blood)
		blood.position = position
		blood.modulate = Color(0, 0.7, 0)
		blood.one_shot = true
		queue_free()
		
	


#implement pathfinding
func chase(delta):
	#harus sesuai pathnya
	enemyTarget = get_node("/root/Root/Level/Player") 
	if (enemyTarget.position-position).length()<attackRange or attacking:
		attacking = true
		attack(delta)
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
	
func attack(delta):
	$AnimatedSprite.animation = "attack"
	$AnimatedSprite.play()
	if $AnimatedSprite.frame == 3:
		if (enemyTarget.position - position).length()<attackRange and !bitten:
			if enemyTarget.playerArmor>0:
				if GlobalVariables.invincible == false:
					enemyTarget.redOverlay = 0.4
					enemyTarget.playerArmor -= 1
				bitten = true
			else:
				if GlobalVariables.invincible == false:
					enemyTarget.redOverlay = 0.4
					enemyTarget.playerHealth -= 1
				bitten = true
	if $AnimatedSprite.frame == 5:
		attacking = false
		bitten = false
		if attackCD > 0.5:
			$AnimatedSprite.frame = 0
			attackCD = 0
		else:
			attackCD += delta
	#TODO EXPLOSION


