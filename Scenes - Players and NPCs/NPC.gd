extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const HEALTH_PICKUP = preload("res://Scenes - Pickups/healthPickup.tscn")
const WEAPON_PICKUP = preload("res://Scenes - Pickups/weaponPickup.tscn")

var maskerOn = false
var timer = 0
var delay = 0
var velocity
var dropping = false

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	var npcType = rand_range(0,100)
	if npcType<25:
		$AnimatedSprite.visible = true
	elif npcType<50:
		$AnimatedSprite2.visible = true
	elif npcType<75:
		$AnimatedSprite3.visible = true
	else:
		$AnimatedSprite4.visible = true
	pass # Replace with function body.


func dropItem():
	var pickup = WEAPON_PICKUP.instance()
	get_parent().add_child(pickup)
	pickup.position = position + Vector2(0,10)

func _physics_process(delta):
	if (maskerOn==true):
		if delay > 0.5:
			timer += delta
			velocity = move_and_slide(velocity)
			if velocity.x > position.x:
				$AnimatedSprite.flip_h = true
				$AnimatedSprite2.flip_h = true
				$AnimatedSprite3.flip_h = true
				$AnimatedSprite4.flip_h = true
			else:
				$AnimatedSprite.flip_h = false
				$AnimatedSprite2.flip_h = false
				$AnimatedSprite3.flip_h = false
				$AnimatedSprite4.flip_h = false
		else:
			delay += delta
	else:
		if (dropping):
			maskerOn = true
			dropItem()
	if timer>5:
		GlobalVariables.npcExists = false
		queue_free()
	else:
		GlobalVariables.npcExists = true

func _on_Area2D_body_entered(body):
	if "playerHealth" in body and maskerOn==false:
		GlobalVariables.npcPosition = Vector2(0, 0)
		body.pesanTimer = 2.5
		dropping = true
		$AnimatedSprite.animation = "walk_masker"
		$AnimatedSprite2.animation = "walk_masker"
		$AnimatedSprite3.animation = "walk_masker"
		$AnimatedSprite4.animation = "walk_masker"
		velocity = (body.position-position).normalized() * -300
