extends Character

class_name Crate

func _ready():
	# Scaling will make the 'Goal' visible when a crate enters it
	$Sprite.scale *= 0.9
