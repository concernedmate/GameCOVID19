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


func _on_AudioStreamPlayer_finished():
	queue_free()


func _on_scorePickup_body_entered(body):
	if "playerArmor" in body:
		ActiveBuffs.doubleScoreTimer = 30
		$AudioStreamPlayer.play()
		visible = false
		collision_layer = 0
		collision_mask = 0
