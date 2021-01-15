extends Character

class_name Player

signal turn_ended(direction, crate_moved)

var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
}

var crate_moved_this_turn: Crate
var direction_this_turn: Vector2

var curr_animation = "move_down"
var curr_animation_frame = 0

func _ready():
	$RayCast2D.set_collide_with_areas(true)
	$AnimatedSprite.animation = curr_animation
	
func _physics_process(delta):
	for dir in inputs.keys():
		if Input.is_action_just_pressed(dir):
			move(inputs[dir])

func is_moveable_to(dir):
	if self.is_moving():
		return false
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
			crate_moved_this_turn = collider
			return true
		else:
			return false
	else:
		return false

func move(direction):
	if self.is_moveable_to(direction):
		self.direction_this_turn = direction
		_set_animation(direction)
		.move(direction)
		emit_signal("turn_ended", direction, crate_moved_this_turn)
		crate_moved_this_turn = null

func _set_animation(direction: Vector2):
	var new_anim
	match direction:
		Vector2.UP:
			new_anim = "move_up"
		Vector2.DOWN:
			new_anim = "move_down"
		Vector2.LEFT:
			new_anim = "move_left"
		Vector2.RIGHT:
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
