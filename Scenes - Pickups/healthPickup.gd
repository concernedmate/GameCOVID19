extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_healthPickup_body_entered(body):
	if "playerHealth" in body:
		body.playerHealth += 0.3 * GlobalVariables.playerMaxHealth
		if (body.playerHealth>GlobalVariables.playerMaxHealth):
			body.playerHealth = GlobalVariables.playerMaxHealth
		$AudioStreamPlayer.play()
		visible = false
		collision_layer = 0
		collision_mask = 0
	pass # Replace with function body.




func _on_AudioStreamPlayer_finished():
	queue_free()
	pass # Replace with function body.
