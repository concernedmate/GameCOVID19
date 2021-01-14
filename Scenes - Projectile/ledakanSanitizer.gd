extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play()
	pass # Replace with function body.

func _on_AnimatedSprite_animation_finished():
	queue_free()
	pass # Replace with function body.


func _on_ledakanSanitizer_body_entered(body):
	if "health" in body:
		body.health -= 40 * GlobalVariables.doubleDamageMult
