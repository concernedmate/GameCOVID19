extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bodies
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if !$AudioStreamPlayer.playing:
		$AudioStreamPlayer.play()
	if $AnimatedSprite.scale.x >= 3.0:
		$AnimatedSprite.scale.x -= 0.05*$AnimatedSprite.scale.x*delta
		$AnimatedSprite.scale.y -= 0.05*$AnimatedSprite.scale.y*delta
		$Area2D.scale.x -= 0.05*$Area2D.scale.x*delta
		$Area2D.scale.y -= 0.05*$Area2D.scale.y*delta
	
	#check player collision
	bodies = $Area2D.get_overlapping_bodies()
	if (bodies != []):
		for x in bodies:
			if "playerHealth" in x:
				x.redOverlay = 0.2
				if x.playerArmor>0:
					x.playerArmor -= 35*delta
				else:
					x.playerHealth -= 35*delta

