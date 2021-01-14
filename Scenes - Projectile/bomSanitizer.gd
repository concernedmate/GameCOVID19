extends Area2D

var target = Vector2()              #moves to this position
var orbSpeed = 750
var timeOut = 1     #time that elapsed before bullet is deleted after it reaches target
var bodies
var onGround = false
var bombScale = 1.35

const ORB_SANITIZER = preload("res://Scenes - Projectile/ledakanSanitizer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if !onGround:
		rotation += 10*delta
	#move
	if (target - position).length() > 10:
		position = position + (target-position).normalized()*orbSpeed*delta
	else:
		var bom = ORB_SANITIZER.instance()
		get_parent().add_child(bom)
		bom.scale.x = bombScale
		bom.scale.y = bombScale
		bom.position = position
		queue_free()
		
