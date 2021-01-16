extends Area2D

class_name Character

signal movement_started
signal movement_ended

var tile_size = Globals.tile_size
var tween_duration = 0.03
onready var ray = $RayCast2D
onready var tween = $Tween
var _tween_in_progress = false

func _ready():
	self.position = self.position.snapped(Vector2.ONE * tile_size)
	self.position += Vector2.ONE * tile_size / 2
	if $Tween:
		$Tween.connect("tween_started", self, "_on_Tween_started")
		$Tween.connect("tween_completed", self, "_on_Tween_ended")

func is_moveable_to(dir):
	if !self.ray:
		return false
	self.ray.cast_to = dir * tile_size
	self.ray.force_raycast_update()
	return !self.ray.is_colliding()

func move(dir: Vector2):
	if $Tween:
		$Tween.interpolate_property(self, "position",
		self.position, self.position + (dir * tile_size), self.tween_duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$Tween.start()
	else:
		self.position += dir * tile_size

func _on_Tween_started(obj, node):
	self._tween_in_progress = true
	emit_signal("movement_started")
	
func _on_Tween_ended(obj, node):
	self._tween_in_progress = false
	emit_signal("movement_ended")
