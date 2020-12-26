extends Area2D

class_name Character
	
var tile_size = Globals.tile_size
onready var ray = $RayCast2D

func _ready():
	self.position = self.position.snapped(Vector2.ONE * tile_size)
	self.position += Vector2.ONE * tile_size / 2

func is_moveable_to(dir):
	if !self.ray:
		return false
	self.ray.cast_to = dir * tile_size
	self.ray.force_raycast_update()
	return !self.ray.is_colliding()

func move(dir: Vector2):
	if is_moveable_to(dir):
		self.position += dir * tile_size
