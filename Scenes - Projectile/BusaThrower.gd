extends Area2D

var target          #moves to this position
var orbVelocity
var orbSpeed = 400
var timeOut = 0     #time that elapsed before bullet is deleted after it reaches target
var originalPos = Vector2()
var bodies


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	look_at(target)
	#stop movement after some pixel
	if (originalPos-position).length() > 200:
		#then start deleting(or burning)
		if (timeOut>0.1):  
			queue_free()
		else:
			timeOut += delta
	else:
		self.scale.x += 20*delta
		self.scale.y += 20*delta
		position = (position + target.normalized()*orbSpeed*delta)
	
	#
	bodies = get_overlapping_bodies()
	if (bodies != []):
		for x in bodies:
			if "health" in x:
				x.health -= 13.5*GlobalVariables.doubleDamageMult*delta #10 damage per second


