extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bodies

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if $AnimatedSprite.frame == 10:
		queue_free()


func _on_ledakanVirus_body_entered(body):
	if 'playerHealth' in body:
		if GlobalVariables.invincible == false:
			body.redOverlay = 0.4
			if body.playerArmor > 0:
				body.playerArmor -= 5
			else:
				body.playerHealth -= 5
