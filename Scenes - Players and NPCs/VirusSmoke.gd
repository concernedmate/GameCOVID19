extends KinematicBody2D

var target
var targetAcquired = false
var health = 15
const speed = 75
const attackRange = 400
var velocity
var cooldown = 1
var onCamera = false
var smokeCD = 0

#team
var team = 1

const FX_BLOOD_DEATH = preload("res://Scenes - FX/bloodFX_death.tscn")
const BULLET_SMOKE = preload("res://Scenes - Projectile/smokePoison.tscn")

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
	if target.x>position.x:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	if health>0:
		idle()
		if smokeCD > 0.75:
			var smoke = BULLET_SMOKE.instance()
			get_parent().add_child(smoke)
			smoke.position = position + Vector2(0, -31.5)
			smokeCD = 0
		else:
			smokeCD += delta
	else:
		#todo start dying animation
		GlobalVariables.currentEnemyCount -= 1
		dropPickup()
		GlobalVariables.Score += 50 * GlobalVariables.ScoreMult
		var blood = FX_BLOOD_DEATH.instance()
		get_parent().add_child(blood)
		blood.position = position
		blood.modulate = Color(0.5, 0.5, 0.5)
		blood.one_shot = true
		queue_free()


func idle():
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "idle"
	if (targetAcquired==false):
		if onCamera:
			target = position + (Vector2(rand_range(-100,100), rand_range(-100,100))*5)
		else:
			target = get_node("/root/Root/Level/Player").position
		targetAcquired = true
	else:
		if ((target - position).length() > 10):
			velocity = (target-position).normalized() * speed
			velocity = move_and_slide(velocity)
			if (is_on_wall()):
				targetAcquired = false
		else:
			cooldown = 1
			$AnimatedSprite.frame = 0
			$AnimatedSprite.stop()
			targetAcquired = false





func _on_VisibilityNotifier2D_viewport_entered(viewport):
	onCamera = true
	pass # Replace with function body.


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	onCamera = false
	pass # Replace with function body.
