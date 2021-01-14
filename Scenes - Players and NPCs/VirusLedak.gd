extends KinematicBody2D

var target
var targetAcquired = false
var health = 4
const speed = 250
const attackRange = 65
var velocity
var enemyTarget
var naturalSpawn = true
var exploding = false
const ORB_EXPLOSION = preload("res://Scenes - Projectile/ledakanVirus.tscn")

#team
var team = 1

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
	if health>0:
		chase()
	else:
		#todo start dying animation
		attack()
	pass
	


#implement pathfinding
func chase():
	#harus sesuai pathnya
	enemyTarget = get_node("/root/Root/Level/Player") 
	if (enemyTarget.position-position).length()<attackRange or exploding == true:
		attack()
		exploding = true
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
	$AnimatedSprite.animation = "explode"
	$AnimatedSprite.play()
	if $AnimatedSprite.frame == 4:
		var explosion = ORB_EXPLOSION.instance()
		explosion.position = self.position
		get_parent().add_child(explosion)
		explosion.get_node("AnimatedSprite").play()
		if naturalSpawn:
			GlobalVariables.currentEnemyCount -= 1
		dropPickup()
		GlobalVariables.Score += 15 * GlobalVariables.ScoreMult
		queue_free()
	#TODO EXPLOSION

