extends Area2D


# Declare member variables here. Examples:
# definisi weapon type
#0 = Disinfektan Thrower (Flamethrower)
#1 = Shotgun
#2 = MachineGun
#3 = Pistol
var weaponType
var ammo

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var chance = rand_range(0,100)
	if chance<35:
		weaponType = 0
		ammo = 250
		$AnimatedSprite.frame = 1
	elif chance<65:
		weaponType = 1
		ammo = 25
		$AnimatedSprite.frame = 2
	else:
		weaponType = 2
		ammo = 200
		$AnimatedSprite.frame = 0
	pass # Replace with function body.

#func _physics_process(delta):
	#var bodies = get_overlapping_bodies()
	#if Input.is_action_just_pressed("equip"):
	#	for body in bodies:
	#		if "weaponType" in body:
	#			if body.weaponType == weaponType:
	#				body.ammo += ammo
	#			else:
	#				body.weaponType = weaponType
	#				body.ammo = ammo
	#			$AudioStreamPlayer.play()
	#			visible = false
	#			collision_layer = 0
	#			collision_mask = 0

func _on_AudioStreamPlayer_finished():
	queue_free()
	pass # Replace with function body.



func _on_weaponPickup_body_entered(body):
	if "weaponType" in body:
		if body.weaponType == weaponType:
			body.ammo += ammo
		else:
			body.weaponType = weaponType
			body.ammo = ammo
		$AudioStreamPlayer.play()
		visible = false
		collision_layer = 0
		collision_mask = 0
	pass # Replace with function body.
