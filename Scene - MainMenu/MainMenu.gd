extends Node

var almanacActive
var almanacPage

func _ready():
	GlobalVariables.inMainMenu = true
	Savefile.loadSave()
	almanacActive = false
	almanacPage = 1

func _on_highscore_button_up():
	get_tree().change_scene("res://Scene - MainMenu/HighscoreMenu.tscn")
	pass # Replace with function body.


func _on_start_button_up():
	GlobalVariables.inMainMenu = false
	get_tree().change_scene("res://Scene - MainMenu/Prolog.tscn")
	pass # Replace with function body.


func _on_exit_button_up():
	get_tree().quit()
	pass # Replace with function body.

func _on_almanac_button_up():
	if almanacActive:
		almanacActive = false
	else:
		almanacActive = true
	pass # Replace with function body.

func _physics_process(delta):
	if almanacActive:
		$Almanac.visible = true
		$skor2.visible = true
		$skor3.visible = true
		$skor4.visible = true
		$skor5.visible = true
		$skor6.visible = true
		$skor7.visible = true
		$skor8.visible = true
		$skor9.visible = true
		$buttons.visible = false
	else:
		$Almanac.visible = false
		$skor2.visible = false
		$skor3.visible = false
		$skor4.visible = false
		$skor5.visible = false
		$skor6.visible = false
		$skor7.visible = false
		$skor8.visible = false
		$skor9.visible = false
		$buttons.visible = true
	
	#below is crap quality coding because no time left
	if Savefile.scoreArray[0][0]>=5000:
		$skor2.visible = false
		$Almanac/Shroomivirion.disabled = false
		$Almanac/Shroomivirion/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=7500:
		$skor3.visible = false
		$Almanac/Dynavirion.disabled = false
		$Almanac/Dynavirion/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=10000:
		$skor4.visible = false
		$Almanac/Koffingvirion.disabled = false
		$Almanac/Koffingvirion/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=12500:
		$skor5.visible = false
		$Almanac/Tirtavirion.disabled = false
		$Almanac/Tirtavirion/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=15000:
		$skor6.visible = false
		$Almanac/Blastydios.disabled = false
		$Almanac/Blastydios/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=20000:
		$skor7.visible = false
		$Almanac/Genidios.disabled = false
		$Almanac/Genidios/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=40000:
		$skor8.visible = false
		$Almanac/Segaradios.disabled = false
		$Almanac/Segaradios/AnimatedSprite.visible = true
	if Savefile.scoreArray[0][0]>=60000:
		$skor9.visible = false
		$Almanac/Viperous.disabled = false
		$Almanac/Viperous/AnimatedSprite.visible = true
	
	match almanacPage:
		1:
			$Almanac/background/penjelasan1.visible = true
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		2:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = true
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		3:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = true
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		4:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = true
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		5:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = true
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		6:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = true
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		7:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = true
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = false
		8:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = true
			$Almanac/background/penjelasan9.visible = false
		9:
			$Almanac/background/penjelasan1.visible = false
			$Almanac/background/penjelasan2.visible = false
			$Almanac/background/penjelasan3.visible = false
			$Almanac/background/penjelasan4.visible = false
			$Almanac/background/penjelasan5.visible = false
			$Almanac/background/penjelasan6.visible = false
			$Almanac/background/penjelasan7.visible = false
			$Almanac/background/penjelasan8.visible = false
			$Almanac/background/penjelasan9.visible = true
	
	
	

func _on_Gluttonivirion_button_up():
	almanacPage = 1
	pass # Replace with function body.


func _on_Shroomivirion_button_up():
	almanacPage = 2
	pass # Replace with function body.


func _on_Dynavirion_button_up():
	almanacPage = 3
	pass # Replace with function body.


func _on_Koffingvirion_button_up():
	almanacPage = 4
	pass # Replace with function body.


func _on_Tirtavirion_button_up():
	almanacPage = 5
	pass # Replace with function body.


func _on_Blastydios_button_up():
	almanacPage = 6
	pass # Replace with function body.


func _on_Genidios_button_up():
	almanacPage = 7
	pass # Replace with function body.


func _on_Segaradios_button_up():
	almanacPage = 8
	pass # Replace with function body.


func _on_Viperous_button_up():
	almanacPage = 9
	pass # Replace with function body.
