extends Area2D

var target          #moves to this position
var orbVelocity
var orbSpeed = 800
var originalPos = Vector2()
var lengthRandomizer = 1.0
var timeOut = 0
var damage = 5 #aslinya 5
var sudahRotate = false


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func _physics_process(delta):
	look_at(target)
	if !sudahRotate:
		target = target.rotated(deg2rad(rand_range(-15, 15)))
		sudahRotate = true
	#stop movement after some pixel
	if (originalPos-position).length() > 350 * lengthRandomizer:
		#then start deleting(or burning)
		if (timeOut>0.1):  
			queue_free()
		else:
			timeOut += delta
	else:
		position = (position + target.normalized()*orbSpeed*delta)
	



func _on_ShotgunBullet_body_entered(body):
	if "health" in body:
		if body.health  > damage:
			body.health -= damage * GlobalVariables.doubleDamageMult
			queue_free()
		else:
			damage -= body.health
			body.health = 0
	elif "shield" in body:
		queue_free()
	pass # Replace with function body.
