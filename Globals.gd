extends Node

const TILE_SIZE = 64
const MOVE_DURATION = 0.03
const LVL_DONE_MESSAGE_VISIBLE_TIME = 1

func _ready():
	Logger.set_default_output_level(Logger.DEBUG)
