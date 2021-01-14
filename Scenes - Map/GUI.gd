extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func playChangeMap():
	$changeMap.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var weaponType = get_node("/root/Root/Level/Player").weaponType
	#set gui values
	if weaponType != 3:
		$Container_Weapon/bg_weapon/ammo.visible = true
		$Container_Weapon/bg_weapon/ammo.text = str(get_node("/root/Root/Level/Player").ammo)
	else:
		$Container_Weapon/bg_weapon/ammo.visible = false
	$Container_Weapon/bg_weapon/weapon.frame = weaponType
	$Container_Bombs/bg_bomb/ammo_bomb.text = str(GlobalVariables.playerBombs)
	$Container_GUI/HBoxContainer/Bars/HP.value = get_node("/root/Root/Level/Player").playerHealth
	$Container_GUI/HBoxContainer/Bars/Armor.value = get_node("/root/Root/Level/Player").playerArmor
	$Container_Wave/bg/number_wave.text = str(GlobalVariables.waveCount)
	$Container_Score/bg/score_number.text = str(GlobalVariables.Score)
	$WaveClear/TextureProgress.value = get_parent().spawnCD
	
	if ActiveBuffs.doubleScoreTimer>0:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/doubleScore.visible = true
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/doubleScore.value = ActiveBuffs.doubleScoreTimer
	else:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/doubleScore.visible = false
	
	if ActiveBuffs.hasteTimer>0:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/haste.visible = true
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/haste.value = ActiveBuffs.hasteTimer
	else:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/haste.visible = false
		
	if ActiveBuffs.doubleDamageTimer>0:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/dd.visible = true
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/dd.value = ActiveBuffs.doubleDamageTimer
	else:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/dd.visible = false
	
	if ActiveBuffs.invincibleTimer>0:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/invinc.visible = true
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/invinc.value = ActiveBuffs.invincibleTimer
	else:
		$Container_GUI/HBoxContainer/Bars/Node2D/HBoxContainer/invinc.visible = false
		


func _on_changeMap_animation_finished():
	return true
