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

var dir_names = {
	Vector2.RIGHT: 'right',
	Vector2.LEFT: 'left',
	Vector2.UP: 'up',
	Vector2.DOWN: 'down',
}

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
	for dir in inputs.keys():
		if Input.is_action_just_pressed(dir):
			move(inputs[dir])

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
	if is_close(direction, Vector2.UP):
			new_anim = "move_up"
	if is_close(direction, Vector2.DOWN):
			new_anim = "move_down"
	if is_close(direction, Vector2.LEFT):
			new_anim = "move_left"
	if is_close(direction, Vector2.RIGHT):
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

func is_close(direction: Vector2, vector: Vector2):
	return direction.distance_to(vector) < 0.01

func _translate_movement(dir):
	for v in [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]:
		if is_close(dir ,v):
			return dir_names[v]
	return dir
func _on_move_end():
	if last_turn_info['reverse']:
		moves -= 1
	else:
		moves += 1
	Logger.info("Player move #{moves}: {a}".format({'moves': moves,
	 'a': str(_translate_movement(last_turn_info['direction']))}), TAG)
	emit_signal("turn_ended", last_turn_info['direction'], last_turn_info['crate_moved'])
	is_moving = false
