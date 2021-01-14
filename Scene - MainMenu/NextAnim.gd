extends Label

var timer = 0
var timer_limit = 1000000 # in miliseconds
var x = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	x+=0.1
	timer += delta
	if (timer > timer_limit):
		timer -= timer_limit
	visible_characters = x
	if visible_characters==13:
		x=0
