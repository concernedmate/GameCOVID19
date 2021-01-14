extends Area2D

var timeOut = 0     #time that elapsed before bullet is deleted after it reaches target
var bodies

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if timeOut>7:
		queue_free()
	else:
		timeOut+=delta
	
	#check player collision
	bodies = get_overlapping_bodies()
	if (bodies != []):
		for x in bodies:
			if "playerHealth" in x:
				if GlobalVariables.invincible == false:
					x.redOverlay = 0.2
					x.playerHealth -= 1.5*delta #1.5 damage per second


