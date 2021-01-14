extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target = Vector2()
var bodies
var MAX_LENGTH = 2000
var rotate_speed = 0.5
var lifetime = 2.0
var timer = 0
var tembus = false
var hitMult = 1.0
var slowDown = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	pass # Replace with function body.


func _physics_process(delta):
	if timer<lifetime:
		if tembus:
			$RayCast2D.set_collision_mask_bit(0, false)
		rotation += rotate_speed*delta *hitMult
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
				hitMult = slowDown
				if GlobalVariables.invincible == false:
					body.redOverlay = 0.4
					if body.playerArmor>0:
						body.playerArmor -= 15*delta
					else:
						body.playerHealth -= 15*delta
			else:
				hitMult = 1.0
	else:
		queue_free()


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play()
	pass # Replace with function body.
