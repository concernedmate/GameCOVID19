extends KinematicBody2D

var target
var targetAcquired = false
const speed = 100
const attackRange = 25
var velocity
var firstVelocity = Vector2()
var enemyTarget
var spawning = false
var timer = 0

#spawn scene
const ORB_SLIME = preload("res://Scenes - Projectile/BlastydiosSlime.tscn")

#team
var team = 1

func _physics_process(delta):
	if timer <= 5:
		_chase()
		timer += delta
	else:
		_spawn()

#implement pathfinding
func _chase():
	#harus sesuai pathnya
	enemyTarget = get_node("/root/Root/Level/Player") 
	if (enemyTarget.position-position).length()<attackRange or spawning == true:
		_spawn()
	else:
		#no pathfinding yet, just simple move x,y to x,y
		velocity = (enemyTarget.position-position).normalized() * speed
		velocity = move_and_slide(velocity)
		if (firstVelocity.x != 0):
			move_and_slide(firstVelocity)
			if (firstVelocity.x > 0):
				firstVelocity.x -= 10
			else:
				firstVelocity.x += 10
	
func _spawn():
	var slime1 = ORB_SLIME.instance()
	get_parent().add_child(slime1)
	slime1.position = position + Vector2(0, -40)
	slime1.scale.x = 0.75
	slime1.scale.y = 0.75
	slime1.add_to_group("slimes")
	queue_free()

