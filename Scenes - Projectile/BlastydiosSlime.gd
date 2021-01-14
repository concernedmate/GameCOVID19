extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bodies

const ORB_EXPLOSION = preload("res://Scenes - Projectile/Boss_ledakanBlastydios.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()
	add_to_group("BlastydiosSlimes")
	pass # Replace with function body.

func explode():
	var explosion = ORB_EXPLOSION.instance()
	explosion.position = self.position + Vector2(0, 100)
	explosion.scale.x = 2.0 * scale.x
	explosion.scale.y = 2.0 * scale.y
	get_parent().add_child(explosion)
	explosion.get_node("AnimatedSprite").play()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	bodies = get_overlapping_bodies()
	for body in bodies:
		if "playerHealth" in body:
			body.speedMult = 0.5
			if GlobalVariables.invincible == false:
				body.redOverlay = 0.2
				if body.playerArmor > 0:
					body.playerArmor -= 3*delta
				else:
					body.playerHealth -= 3*delta


func _on_AnimatedSprite_animation_finished():
	$CollisionPolygon2D.disabled = false


func _on_BlastydiosSlime_body_exited(body):
	if "playerHealth" in body:
		body.speedMult = 1.0
