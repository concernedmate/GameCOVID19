extends KinematicBody2D

const originalSpeed = 300
var speed = 300
var speedMult = 1.0 #buat slow only

var velocity = Vector2()
var mousePos = Vector2()
var playerHealth = 20
var playerArmor = 0
var maskVar = ""
var dashing = 0
var pesanTimer = 0
var deadTimer = 0
var penunjukNPCTimer = 0
var redOverlay = 0
const ORB_BUSA_FLAMETHROWER = preload("res://Scenes - Projectile/BusaThrower.tscn")
const ORB_BULLET_SHOTGUN = preload("res://Scenes - Projectile/ShotgunBullet.tscn")
const ORB_BULLET_PISTOL = preload("res://Scenes - Projectile/PistolBullet.tscn")
const ORB_BULLET_MACHINE = preload("res://Scenes - Projectile/MachineGunBullet.tscn")
const ORB_BOMB = preload("res://Scenes - Projectile/bomSanitizer.tscn")

#definisi weapon type
#0 = Disinfektan Thrower (Flamethrower)
#1 = Shotgun
#2 = MachineGun
#3 = Pistol
#4 = RocketLauncher
var weaponType = 3
var weaponCD = 0
var firstShot = true
var weaponTimer = 0
var ammo = 0
onready var originalWeaponPos = $Weapon/Sprite.position 

#definisi skill type
#0 = bomb lempar (default)
#1 = 
#2 = 
#3 = 

var team = 0

func get_walk_input():
	velocity = Vector2()
	var isWalking = false
	if Input.is_action_pressed("ui_right"):
		velocity.x = 1
		isWalking = true
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
		isWalking = true
	if Input.is_action_pressed("ui_down"):
		velocity.y = 1
		isWalking = true
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
		isWalking = true
	velocity = velocity.normalized() *speed *speedMult *GlobalVariables.playerHasteMult
	return isWalking

#_TODO ROCKET LAUNCHER
func shoot(delta):
	#check weapon type
	match weaponType:    #switch case statement klo di bhs lain
		0: #flamethrower
			weaponCD = 0.05
			if weaponTimer > weaponCD:
				#this actually spawns stuff
				var bullet = ORB_BUSA_FLAMETHROWER.instance()       #create new node
				var target = get_global_mouse_position()
				get_parent().add_child(bullet)    #make the new node as child of root
				bullet.position = position + (target - position).normalized() * 30
				bullet.position.y += 13           #ini koreksi karena keluarnya gak pas
				bullet.originalPos = position + (target - position).normalized() * 30
				bullet.originalPos.y += 13
				bullet.target = target - position + Vector2(rand_range(-75,75), rand_range(-75,75))
				weaponTimer = 0
				ammo -= 1
			else:
				weaponTimer += delta
		1: #shotgun 
			weaponCD = 0.5
			#THIS LOOKS ABSOLUTELY TERRIBLE PLZ FIX
			#cek apakah tembakan pertama
			if weaponTimer > weaponCD or firstShot:
				$Shotgun_SFX.play()
				#this actually spawns stuff
				var bullet1 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var bullet2 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var bullet3 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var bullet4 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var bullet5 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var bullet6 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var bullet7 = ORB_BULLET_SHOTGUN.instance()       #create new node
				var target = get_global_mouse_position()
				
				get_parent().add_child(bullet1)    #make the new node as child of root
				get_parent().add_child(bullet2)    #make the new node as child of root
				get_parent().add_child(bullet3)    #make the new node as child of root
				get_parent().add_child(bullet4)    #make the new node as child of root
				get_parent().add_child(bullet5)    #make the new node as child of root
				get_parent().add_child(bullet6)    #make the new node as child of root
				get_parent().add_child(bullet7)    #make the new node as child of root
				
				bullet1.position = position + (target - position).normalized() * 15
				bullet1.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet1.originalPos = position + (target - position).normalized() * 15
				bullet1.originalPos.y += 15
				
				bullet2.position = position + (target - position).normalized() * 15
				bullet2.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet2.originalPos = position + (target - position).normalized() * 15
				bullet2.originalPos.y += 15
				
				bullet3.position = position + (target - position).normalized() * 15
				bullet3.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet3.originalPos = position + (target - position).normalized() * 15
				bullet3.originalPos.y += 15
				
				bullet4.position = position + (target - position).normalized() * 15
				bullet4.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet4.originalPos = position + (target - position).normalized() * 15
				bullet4.originalPos.y += 15
				
				bullet5.position = position + (target - position).normalized() * 15
				bullet5.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet5.originalPos = position + (target - position).normalized() * 15
				bullet5.originalPos.y += 15
				
				bullet6.position = position + (target - position).normalized() * 15
				bullet6.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet6.originalPos = position + (target - position).normalized() * 15
				bullet6.originalPos.y += 15
				
				bullet7.position = position + (target - position).normalized() * 15
				bullet7.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet7.originalPos = position + (target - position).normalized() * 15
				bullet7.originalPos.y += 15
				
				bullet1.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				bullet2.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				bullet3.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				bullet4.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				bullet5.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				bullet6.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				bullet7.target = target - position #+ Vector2(rand_range(-90,90), rand_range(-90,90))
				
				bullet1.orbSpeed = bullet1.orbSpeed * rand_range(0.75,1.25)
				bullet2.orbSpeed = bullet2.orbSpeed * rand_range(0.75,1.25)
				bullet3.orbSpeed = bullet3.orbSpeed * rand_range(0.75,1.25)
				bullet4.orbSpeed = bullet4.orbSpeed * rand_range(0.75,1.25)
				bullet5.orbSpeed = bullet5.orbSpeed * rand_range(0.75,1.25)
				bullet6.orbSpeed = bullet6.orbSpeed * rand_range(0.75,1.25)
				bullet7.orbSpeed = bullet7.orbSpeed * rand_range(0.75,1.25)
				
				bullet1.lengthRandomizer = rand_range(0.75,1.25)
				bullet2.lengthRandomizer = rand_range(0.75,1.25)
				bullet3.lengthRandomizer = rand_range(0.75,1.25)
				bullet4.lengthRandomizer = rand_range(0.75,1.25)
				bullet5.lengthRandomizer = rand_range(0.75,1.25)
				bullet6.lengthRandomizer = rand_range(0.75,1.25)
				bullet7.lengthRandomizer = rand_range(0.75,1.25)
				
				weaponTimer = 0
				ammo -= 1
				firstShot = false
				$Weapon/Sprite.position = (target-$Weapon/Sprite.position).normalized() * -0.7
			else:
				$Weapon/Sprite.position += Vector2(0.5, 0.5)
				weaponTimer += delta
		2: #machinegun
			weaponCD = 0.1
			if weaponTimer > weaponCD or firstShot:
				$MachineGun_SFX.play()
				#this actually spawns stuff
				var bullet = ORB_BULLET_MACHINE.instance()       #create new node
				var target = get_global_mouse_position()
				get_parent().add_child(bullet)    #make the new node as child of root
				bullet.position = position + (target - position).normalized() * 50
				bullet.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet.originalPos = position + (target - position).normalized() * 50
				bullet.originalPos.y += 15
				target += velocity.normalized() * 75
				bullet.target = target - position + Vector2(rand_range(-15,15), rand_range(-15,15))
				bullet.rotation = $Weapon.rotation
				weaponTimer = 0
				firstShot = false
				ammo -= 1
				$Camera2D.shake(0.3, 5, 3)
			else:
				weaponTimer += delta
		3: #pistol
			weaponCD = 0.35
			if weaponTimer > weaponCD or firstShot:
				$Pistol_SFX.play()
				#this actually spawns stuff
				var bullet = ORB_BULLET_PISTOL.instance()       #create new node
				var target = get_global_mouse_position()
				
				get_parent().add_child(bullet)    #make the new node as child of root
				bullet.position = position + (target - position).normalized() * 50
				bullet.position.y += 15           #ini koreksi karena keluarnya gak pas
				bullet.originalPos = position + (target - position).normalized() * 50
				bullet.originalPos.y += 15
				target += velocity.normalized() * 75
				bullet.target = target - position + Vector2(rand_range(-10,10), rand_range(-10,10))
				bullet.rotation = $Weapon.rotation
				weaponTimer = 0
				firstShot = false
			else:
				weaponTimer += delta
		

func throw(delta):
	var bom = ORB_BOMB.instance()
	var target = get_global_mouse_position()
	get_parent().add_child(bom)
	bom.position = position
	bom.target = target
	

func pesan(delta):
	if pesanTimer>0:
		$pesan.play()
		$pesan.visible = true
		if $pesan.frame == 3:
			$pesan/pesan_text.visible = true
		else:
			$pesan/pesan_text.roll_text()
		pesanTimer-=delta
	else:
		$pesan.frame = 0
		$pesan.visible = false
		$pesan/pesan_text.visible = false


func _physics_process(delta):
	if playerArmor>0:
		maskVar = ""
	else:
		maskVar = "_nomask"

	#set weapon sprite
	match weaponType:
		0:
			$Weapon/Sprite.frame = 0
		1:
			$Weapon/Sprite.frame = 2
		2:
			$Weapon/Sprite.frame = 1
		3:
			$Weapon/Sprite.frame = 3
	
	if playerHealth > 0:
		#heath damage effect/red blink
		if redOverlay>0:
			$PlayerSprite.modulate = Color(0.9, 0.2, 0.2)
			$Weapon/Sprite.modulate = Color(0.9, 0.2, 0.2)
			redOverlay-=delta
		else:
			$PlayerSprite.modulate = Color(1, 1, 1)
			$Weapon/Sprite.modulate = Color(1, 1, 1)
		
		#dash
		if dashing<0.2:
			set_collision_layer_bit(0, true)
			set_collision_mask_bit(0, true)
			set_collision_layer_bit(1, true)
			set_collision_mask_bit(1, true)
			set_collision_layer_bit(5, true)
			set_collision_mask_bit(5, true)
			$dashparticle.emitting = false
			speed = 300
		if dashing>0:
			dashing -= delta
		
		#jalan
		if get_walk_input():
			if !$Walk_SFX.playing:
				$Walk_SFX.play()
			$PlayerSprite.animation = "walk"+maskVar
		else:
			$PlayerSprite.animation = "idle"+maskVar
			$Walk_SFX.stop()
		velocity = move_and_slide(velocity)
		
		#arah senjata
		mousePos = get_global_mouse_position()
		if mousePos.x < position.x:
			$PlayerSprite.flip_h = true
			$Weapon/Sprite.flip_v = true
		else:
			$PlayerSprite.flip_h = false
			$Weapon/Sprite.flip_v = false
		$Weapon.look_at(mousePos)
			
		#nembak
		if Input.is_action_pressed("click") and (position-mousePos).length()>50:
			#sound effect busa doang yg disini agar tidak overlap
			if weaponType==0:
				if !$Busa_SFX.playing:
					$Busa_SFX.play()
			else:
				$Busa_SFX.stop()
			shoot(delta)
		else:
			$Busa_SFX.stop()
			#agar tembakan pertama tidak kena efek cd weapon
			if weaponTimer > weaponCD:
				firstShot = true
			else:
				$Weapon/Sprite.position = originalWeaponPos 
				weaponTimer += delta
		
		#lempar bom
		if Input.is_action_just_pressed("lemparBom") and GlobalVariables.playerBombs>0:
			$Lempar_SFX.play()
			throw(delta)
			GlobalVariables.playerBombs -= 1
		
		#dash
		if Input.is_action_just_pressed("dash") and dashing <= 0:
			dashing = 0.4
			$dashparticle.emitting = true
			speed = 600
			$Dash_SFX.play()
			set_collision_layer_bit(0, false)
			set_collision_mask_bit(0, false)
			set_collision_layer_bit(1, false)
			set_collision_mask_bit(1, false)
			set_collision_layer_bit(5, false)
			set_collision_mask_bit(5, false)
		
		#reset weapon type
		if ammo == 0:
			weaponType = 3
		
		#pesan buat npc
		pesan(delta)
		
		#penunjuk arah npc
		if GlobalVariables.npcPosition:
			if penunjukNPCTimer>5:
				$panah.visible = true
				$panah.look_at(GlobalVariables.npcPosition)
			else:
				penunjukNPCTimer+=delta
		else:
			$panah.visible = false
			
		#vfxs
		if ActiveBuffs.doubleDamageTimer>0:
			$Weapon/dd_vfx.visible = true
		else:
			$Weapon/dd_vfx.visible = false
		if ActiveBuffs.hasteTimer>0:
			$vfx/haste_vfx.visible = true
		else:
			$vfx/haste_vfx.visible = false
		if ActiveBuffs.doubleScoreTimer>0:
			$Weapon/ds_vfx.visible = true
		else:
			$Weapon/ds_vfx.visible = false
		if  ActiveBuffs.invincibleTimer>0:
			$vfx/shield_vfx.visible = true
		else:
			$vfx/shield_vfx.visible = false
		
	else:
		#die
		$PlayerSprite.modulate = Color(1, 1, 1)
		$Weapon/Sprite.modulate = Color(1, 1, 1)
		$PlayerSprite.play("dead"+maskVar)
		$Weapon.visible = false
		if deadTimer>5:
			if get_node("/root/Root/GUI")._on_changeMap_animation_finished():
				get_tree().change_scene("res://Scene - EndGame/EndGame.tscn")
		else:
			if deadTimer>4:
				get_node("/root/Root/GUI").playChangeMap()
			deadTimer+=delta
			
	
	

