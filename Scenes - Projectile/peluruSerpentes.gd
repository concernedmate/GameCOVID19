extends Area2D

var target = Vector2()              #moves to this position
var orbSpeed = 300
var timeOut = 1     #time that elapsed before bullet is deleted after it reaches target
var bodies
var onGround = false
var dead = false
var originalPos = Vector2()
const range_length = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if !onGround:
		look_at(target)
		onGround = true
		
	if dead:
		$Sprite.visible = false
		$AnimatedSprite2.visible = true
		$CollisionShape2D.disabled = true
		$AnimatedSprite2.play()
	else:
		position = position + target.normalized()*orbSpeed*delta
		
	if (originalPos-position).length()>range_length:
		dead = true


func _on_AnimatedSprite2_animation_finished():
	queue_free()
	pass # Replace with function body.


func _on_peluruSerpentes_body_entered(body):
	if "playerHealth" in body:
		if GlobalVariables.invincible == false:
			body.redOverlay = 0.4
			if body.playerArmor > 0:
				body.playerArmor -= 1
			else:
				body.playerHealth -= 1
	dead = true
	pass # Replace with function body.
