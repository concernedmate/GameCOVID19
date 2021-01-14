extends KinematicBody2D

var shield
var speed = 250
var cooldown = 2
var attacking = false
var velocity
var target = Vector2()
var shooting = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#harus sesuai pathnya
	if (position!=target):
		if (target-position).length()<10:
			position = target
		else:
			#no pathfinding yet, just simple move x,y to x,y
			velocity = (target-position).normalized() * speed
			velocity = move_and_slide(velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (("playerHealth" in collision.collider) or ("health" in collision.collider)):
			collision.collider.move_and_slide((target-position).normalized() * speed)
	
	
	#damage stuff dibawah
	if cooldown <= 0.15:
		cooldown+=delta
	var bodies = $Area2D.get_overlapping_bodies()
	for body in bodies: 
		if "playerHealth" in body and cooldown > 0.15 and attacking:
			if GlobalVariables.invincible == false:
				body.redOverlay = 0.4
				if body.playerArmor > 0:
					body.playerArmor -= 5
				else:
					body.playerHealth -= 5
				cooldown = 0
