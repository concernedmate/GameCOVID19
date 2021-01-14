extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var startCount = false
var count = 0


# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	if GlobalVariables.waveCount%5==1: #bar hanya visible di wave selain boss wave
		$TextureProgress.visible = false
	else:
		$TextureProgress.visible = true
	if startCount == true:
		if count > 3:
			startCount= false
			visible = false
			count = 0
		else:
			count += delta
	pass # Replace with function body.


func _on_WaveClear_animation_finished():
	startCount = true
	pass # Replace with function body.
