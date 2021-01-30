extends Area2D

class_name BlockSprite

var tile_size = Globals.TILE_SIZE

func _ready():
	self.position = self.position.snapped(Vector2.ONE * tile_size)
	self.position += Vector2.ONE * tile_size / 2
