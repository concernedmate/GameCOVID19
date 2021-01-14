extends Node2D


# Declare member variables here. Examples:
onready var target = Vector2()
var bodies
var MAX_LENGTH = 3000
var lifetime = 3.0
var timer = 0
var speed = 5.0
var accel = 1.0
var maxScale = 4.5
var damage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	scale.x = 0.1
	scale.y = 0.1
	modulate.a = 0.1
	pass # Replace with function body.


func _physics_process(delta):
	if timer<lifetime:
		if scale.x < maxScale:
			scale.x += speed * delta
			scale.y += speed * delta
			speed += accel * delta
			modulate.a += 0.2
		else:
			modulate.a = 1.0
			damage = 20
		$RayCast2D.cast_to = target.normalized() * MAX_LENGTH
		if $RayCast2D.is_colliding():
			$End.global_position = $RayCast2D.get_collision_point()
		else:
			$End.global_position = $RayCast2D.cast_to
		$Beam.rotation = $RayCast2D.cast_to.angle()
		$Beam.region_rect.end.x = $End.position.length()
		timer+= delta
		bodies = $End.get_overlapping_bodies()
		for body in bodies:
			if "playerHealth" in body:
				if GlobalVariables.invincible == false:
					body.redOverlay = 0.4
					if body.playerArmor>0:
						body.playerArmor -= damage*delta
					else:
						body.playerHealth -= damage*delta
	else:
		queue_free()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.
