extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var doubleScoreTimer = 0
var doubleDamageTimer = 0
var hasteTimer = 0
var invincibleTimer = 0

func doubleScore(delta):
	if doubleScoreTimer > 0:
		doubleScoreTimer-=delta
		GlobalVariables.ScoreMult = 2.0
	else:
		GlobalVariables.ScoreMult = 1.0

func haste(delta):
	if hasteTimer > 0:
		hasteTimer -=delta
		GlobalVariables.playerHasteMult = 1.35
	else:
		GlobalVariables.playerHasteMult = 1.0

func doubleDamage(delta):
	if doubleDamageTimer > 0:
		doubleDamageTimer -=delta
		GlobalVariables.doubleDamageMult = 2.0
	else:
		GlobalVariables.doubleDamageMult = 1.0

func invincibility(delta):
	if invincibleTimer > 0:
		invincibleTimer -=delta
		GlobalVariables.invincible = true
	else:
		GlobalVariables.invincible = false

func _physics_process(delta):
	doubleScore(delta)
	haste(delta)
	doubleDamage(delta)
	invincibility(delta)
