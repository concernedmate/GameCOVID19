extends Node2D


# Declare member variables here. Examples:
onready var target = Vector2()
var bodies
const MAX_LENGTH = 2000
var timer = 0
var arah_randomizer = 1
var hitMult = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var chance = rand_range(0, 100)
	if chance<50:
		arah_randomizer = 1
	else:
		arah_randomizer = -1
	rotation_degrees -= 60 * arah_randomizer
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	if timer<2.0:
		rotation += delta * arah_randomizer * hitMult
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
				hitMult = 0.35 #subjek nerf
				if GlobalVariables.invincible == false:
					body.redOverlay = 0.4
					if body.playerArmor>0:
						body.playerArmor -= 10*delta
					else:
						body.playerHealth -= 10*delta
			else:
				hitMult = 1.0
	else:
		queue_free()
