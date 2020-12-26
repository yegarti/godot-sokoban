extends Character

func _ready():
	# Scaling will make the 'Goal' visible when a crate enters it
	$Sprite.scale *= 0.9
