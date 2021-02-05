extends Character

class_name Player

signal turn_ended(direction, crate_moved)
const TAG = "Player"

var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
}

onready var helper = load("res://utils/Helper.gd").new()

const INPUT_DELAY = 0.2
var _delay_from_last_input = 0

var curr_animation = "move_down"
var curr_animation_frame = 0
var is_moving = false
var last_turn_info = {'crate_moved': null, 'reverse': false, 'direction': Vector2.ZERO}
var moves = 0
var pushes = 0

func _ready():
	$RayCast2D.set_collide_with_areas(true)
	$AnimatedSprite.animation = curr_animation
	self.connect("movement_ended", self, "_on_move_end")
	
func _physics_process(delta):
	_delay_from_last_input += delta
	get_input()

func get_input():
	for dir in inputs.keys():
		if Input.is_action_just_pressed(dir):
			move(inputs[dir])
			_delay_from_last_input = 0
		elif Input.is_action_pressed(dir) and _delay_from_last_input > INPUT_DELAY:
			move(inputs[dir])
			_delay_from_last_input = 0

func is_moveable_to(dir):
	self.ray.cast_to = dir * tile_size
	self.ray.force_raycast_update()
	var collider = ray.get_collider()
	if !collider:
		return true
	elif collider.has_method("is_moveable_to"):
		# edge case can make Player colide with itself
		if not collider as Player and \
		collider.is_moveable_to(dir):
			collider.move(dir)
			last_turn_info['crate_moved'] = collider
			return true
		else:
			return false
	else:
		return false

func move(direction, reversing=false):
	if self.is_moving:
		return
	self.is_moving = true
	last_turn_info.clear()
	last_turn_info['crate_moved'] = null
	if self.is_moveable_to(direction):
		last_turn_info['reverse'] = reversing
		last_turn_info['direction'] = direction
		_set_animation(direction, reversing)
		.move(direction)
	else:
		is_moving = false

func _set_animation(direction: Vector2, reverse: bool):
	if reverse:
		direction = direction.rotated(PI)

	var new_anim
	if helper.is_close(direction, Vector2.UP):
			new_anim = "move_up"
	if helper.is_close(direction, Vector2.DOWN):
			new_anim = "move_down"
	if helper.is_close(direction, Vector2.LEFT):
			new_anim = "move_left"
	if helper.is_close(direction, Vector2.RIGHT):
			new_anim = "move_right"

	if new_anim == curr_animation:
		_set_next_frame()
	else:
		$AnimatedSprite.animation = new_anim
		curr_animation = new_anim

func _set_next_frame():
	# Animation is set frame by frame because 'play' animation is too fast and
	# short to be noticed
	$AnimatedSprite.frame = ($AnimatedSprite.frame + 1) % \
		$AnimatedSprite.frames.get_frame_count(curr_animation)

func _on_move_end():
	emit_signal("turn_ended", last_turn_info['direction'], last_turn_info['crate_moved'])
	is_moving = false
