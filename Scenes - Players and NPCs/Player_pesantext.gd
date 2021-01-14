extends Label


# Declare member variables here. Examples:
# var a = 2
#BIASAKAN CUCI TANGAN YA!
#JAGA JARAK 1 METER
#MAKAN MAKANAN BERGIZI
#PAKAI MASKER SAAT BEPERGIAN
#GUNAKAN HAND SANITIZER!
#STAYHOME
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func roll_text():
	randomize()
	var chance = RandomNumberGenerator.new()
	chance.randomize()
	var number = chance.randi_range(0, 5)
	match number:
		0:
			text = "BIASAKAN CUCI TANGAN  YA!"
		1:
			text = "JAGA JARAK 1 METER  YA!"
		2:
			text = "MAKAN MAKANAN BERGIZI!"
		3:
			text = "PAKAI MASKER SAAT BEPERGIAN!"
		4:
			text = "CUCI TANGAN SEBELUM MAKAN!"
		5:
			text = "STAYHOME"
