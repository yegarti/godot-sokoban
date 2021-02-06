extends Node

const TILE_SIZE = 64
const MOVE_DURATION = 0.03
const LVL_DONE_MESSAGE_VISIBLE_TIME = 1
const CONTINUES_MOVEMENT_DELAY = 0.2
const LEVELS_PATH = "res://levels/"

var curr_level_pack_file = "res://levels/basic.txt"
var curr_level_pack_name = "Basics"
onready var level_packs = []

func _ready():
	Logger.set_default_output_level(Logger.DEBUG)
	_find_all_level_packs()
	

func _find_all_level_packs():
	var dir = Directory.new()
	dir.open(LEVELS_PATH)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif file.ends_with(".txt"):
			level_packs.append(LEVELS_PATH + file)
	dir.list_dir_end()
