extends Area2D

var timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func startQueue(delta):
	if timer>10:
		queue_free()
	else:
		timer += delta

func _physics_process(delta):
	if $AnimatedSprite.frame == 4:
		$AnimatedSprite2.play()
		$AnimatedSprite.stop()
		$CollisionShape2D.disabled = false
	if $AnimatedSprite2.frame == 3:
		if !$AudioStreamPlayer.playing:
			$AudioStreamPlayer.play()
	if $AnimatedSprite2.frame == 9:
		$CollisionShape2D.disabled = true
	if $AnimatedSprite2.frame == 11:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.frame = 5
		startQueue(delta)

func _on_ledakanGenidios1_body_entered(body):
	if 'playerHealth' in body:
		if GlobalVariables.invincible == false:
			body.redOverlay = 0.4
			if body.playerArmor > 0:
				body.playerArmor -= 5
			else:
				body.playerHealth -= 5
