extends KinematicBody2D

var target
var targetAcquired = false

#HP
var health = 2000
var healthBar

const speed = 750
const attackRange = 75
var didRoar = false
var didDyingRoar = false
var trackingRangeLimit = 250 #tracking posisi jatuh hingga jaraknya segini
var maxCombo = 2 #jumlah combo yg dpt dilakukan
var currentCombo = 0
var velocity
var attackTarget = Vector2() #posisi jatuh
var enemyTarget #node yg dianggap musuh/player
var attacking = false
var attackTimer = 0 #timer sebelum attack lg
var attackCD = 3 #cooldown sebelum attack
var attackDelay = 0.5 #delay serangan combo
var phase = 1 #skrg phase apa
var explosionSize = 2.25 #besar ledakan pukulan

#load FX
const FX_BLOOD_DEATHBOSS = preload("res://Scenes - FX/bloodFX_bossdeath.tscn")

const HP_BAR = preload("res://Scenes - Map/HPBARBOSS.tscn")
const ORB_EXPLOSION = preload("res://Scenes - Projectile/Boss_ledakanBlastydios.tscn")
const ORB_SLIME = preload("res://Scenes - Projectile/BlastydiosSlime.tscn")
const FX_ROAR = preload("res://Scenes - FX/roarEffect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	healthBar = HP_BAR.instance()
	get_node("/root/Root/GUI/Container_BossHP").add_child(healthBar)
	healthBar.max_value = 2000
	healthBar.changeText("Blastydios")
	GlobalVariables.bossAlive += 1
	GlobalVariables.bossPhaseSpawnCreep = true
	pass # Replace with function body.

func _physics_process(delta):
	healthBar.value = health
	if health<=1500:
		if phase == 1:
			phase = 2
			didRoar = false
		attackDelay = 0.1
		maxCombo = 4
		attackCD = 1.5
		trackingRangeLimit = 150
		explosionSize = 2.5
	if health<=1000:
		if phase == 2:
			phase = 3
			didRoar = false
		explosionSize = 2.75
		maxCombo = 5
	
	if get_tree().get_nodes_in_group("slimes").size()>=10:
		didRoar = false
	
	enemyTarget = get_node("/root/Root/Level/Player") 
	if enemyTarget.position.x>position.x:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
		
	
	if health>0:
		if didRoar:
			idle(delta)
		else:
			roar(delta)
	else:
		#todo start dying animation
		if didDyingRoar:
			GlobalVariables.bossAlive -= 1
			GlobalVariables.Score += 5000
			var blood = FX_BLOOD_DEATHBOSS.instance()
			get_parent().add_child(blood)
			blood.position = position
			blood.modulate = Color(0, 0.7, 0)
			blood.one_shot = true
			queue_free()
		else:
			roar(delta)
		

func idle(delta):
	if attackTimer<attackCD:
		$AnimatedSprite.animation = "idle"
		$AnimatedSprite.play()
		attackTimer += delta
	else:
		if health<=1000 and currentCombo >= maxCombo:
			sebarSlime()
		else:
			chase(delta)

#implement pathfinding
func chase(delta):
	#ambil target jump
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(1, true)
	set_collision_mask_bit(1, true)
	if !targetAcquired:
		attackTarget = enemyTarget.position
		if (attackTarget-position).length()<trackingRangeLimit:
			targetAcquired = true
		
	if (attackTarget-position).length()<attackRange or attacking:
		attacking = true
		attack(delta)

	else:
		$AnimatedSprite.play()
		$AnimatedSprite.animation = "air"
		#no pathfinding yet, just simple move x,y to x,y
		velocity = (attackTarget-position).normalized() * speed
		velocity = move_and_slide(velocity)
	
func attack(delta):
	set_collision_layer_bit(0, true)
	set_collision_mask_bit(0, true)
	set_collision_layer_bit(1, false)
	set_collision_mask_bit(1, false)
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "drop"
	if $AnimatedSprite.frame == 5:
		targetAcquired = false
		attacking = false
		if currentCombo<maxCombo:
			attackTimer = attackCD-attackDelay
			currentCombo+=1
		else:
			attackTimer = 0
			currentCombo = 0
		var explosion = ORB_EXPLOSION.instance()
		explosion.position = self.position + Vector2(0, 50)
		explosion.scale.x = explosionSize
		explosion.scale.y = explosionSize
		get_parent().add_child(explosion)
		explosion.get_node("AnimatedSprite").play()
		#too hard lol
		if health<=1000 and currentCombo%2==0:
			var slime = ORB_SLIME.instance()
			get_parent().add_child(slime)
			slime.position = position - Vector2(0, 75)
			slime.add_to_group("slimes")

func sebarSlime():
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "slash"
	if $AnimatedSprite.frame == 5:
		var slime1 = ORB_SLIME.instance()
		get_parent().add_child(slime1)
		slime1.position = position - Vector2(0, 75)
		slime1.scale.x = 1.5
		slime1.scale.y = 1.5
		slime1.add_to_group("slimes")
		currentCombo = 0

func roar(delta):
	$AnimatedSprite.play()
	$AnimatedSprite.animation = "roar"
	
	#sounds
	if $roar_usual.playing:
		if !get_tree().get_nodes_in_group("slimes").size()>=10:
			$roar_usual.pitch_scale += 0.1 * delta
		else:
			$roar_ultimate.pitch_scale += 0.1 * delta
	
	if $AnimatedSprite.frame == 3 or $AnimatedSprite.frame == 5:
		#sounds
		if !$roar_usual.playing and $AnimatedSprite.frame == 3:
			if !get_tree().get_nodes_in_group("slimes").size()>=10:
				$roar_usual.play()
			else:
				$roar_ultimate.play()
		
		#roar effect
		var roarFX = FX_ROAR.instance()
		get_parent().add_child(roarFX)
		roarFX.position = position + Vector2(0, 1)
		
	if $AnimatedSprite.frame == 11:
		didRoar = true
		attackTimer = attackCD
		if get_tree().get_nodes_in_group("slimes").size()>=10:
			ultimate()
		if health<=0:
			ultimate()
			didDyingRoar = true

func ultimate():
	get_tree().call_group("slimes", "explode")


func _on_roar_usual_finished():
	$roar_usual.pitch_scale = 0.8


func _on_roar_ultimate_finished():
	$roar_ultimate.pitch_scale = 1
