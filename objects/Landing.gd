extends Character

func _ready():
	# Decrease collosion by abit to avoid edge detection with creates in adjacent block
	$CollisionShape2D.scale *= 0.9
