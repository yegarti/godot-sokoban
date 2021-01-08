extends Character

var inputs = {
	"ui_right": Vector2.RIGHT,
	"ui_left": Vector2.LEFT,
	"ui_up": Vector2.UP,
	"ui_down": Vector2.DOWN,
}

var crate_moved_this_turn: Crate
signal turn_ended(direction, crate_moved)

func _ready():
	$RayCast2D.set_collide_with_areas(true)
	
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
		if collider.is_moveable_to(dir):
			collider.move(dir)
			crate_moved_this_turn = collider
			return true
		else:
			return false
	else:
		return false

func move(direction):
	if self.is_moveable_to(direction):
		.move(direction)
		emit_signal("turn_ended", direction, crate_moved_this_turn)
		crate_moved_this_turn = null
