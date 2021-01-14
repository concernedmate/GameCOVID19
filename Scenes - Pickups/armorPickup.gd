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


func _on_armorPickup_body_entered(body):
	if "playerArmor" in body:
		body.playerArmor = 10
		$AudioStreamPlayer.play()
		visible = false
		collision_layer = 0
		collision_mask = 0
	pass # Replace with function body.


func _on_AudioStreamPlayer_finished():
	queue_free()
	pass # Replace with function body.
