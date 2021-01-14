extends Area2D

var target          #moves to this position
var orbVelocity
var orbSpeed = 800
var originalPos = Vector2()
var lengthRandomizer = 1.0
var damage = 4
var dead = false
var timer = 0
var rotateEffect = 1
var sudahRotated = false
const range_length = 1000

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var chance = rand_range(0, 100)
	if chance <50:
		rotateEffect = -1
	pass # Replace with function body.


func _physics_process(delta):
	if dead:
		$CollisionShape2D.disabled = true
		$AnimatedSprite.play()
		if !sudahRotated:
			$AnimatedSprite.rotate(deg2rad(60*rotateEffect))
			sudahRotated = true
		if timer > 0.2:
			queue_free()
		else:
			timer += delta
	else:
		position = position + target.normalized()*orbSpeed*delta
		
	if (originalPos-position).length()>range_length:
		dead = true


func _on_PistolBullet_body_entered(body):
	if "health" in body:
		body.health -= damage * GlobalVariables.doubleDamageMult
		dead = true
	else:
		dead = true
	pass # Replace with function body.
