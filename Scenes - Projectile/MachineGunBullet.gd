extends Area2D

var target          #moves to this position
var orbVelocity
var orbSpeed = 800
var originalPos = Vector2()
var lengthRandomizer = 1.0
var timeOut = 0
var damage = 4
var dead = false
const range_length = 1500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if dead:
		$AnimatedSprite.play()
		$Sprite.visible = false
		$CollisionShape2D.disabled = true
	else:
		position = position + target.normalized()*orbSpeed*delta
	
	if (originalPos-position).length()>range_length:
		dead = true
	
	

func _on_MachineGunBullet_body_entered(body):
	if "health" in body:
		body.health -= damage * GlobalVariables.doubleDamageMult
		dead = true
	else:
		dead = true
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	queue_free()
