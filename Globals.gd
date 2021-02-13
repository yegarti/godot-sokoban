extends Node

const TILE_SIZE = 64
const MOVE_DURATION = 0.03
const LVL_DONE_MESSAGE_VISIBLE_TIME = 1
const CONTINUES_MOVEMENT_DELAY = 0.2
const LEVELS_PATH = "res://levels/"

var current_level_pack
var current_level_id = 1

onready var level_packs = {}

func _ready():
	Logger.set_default_output_level(Logger.DEBUG)
	_find_all_level_packs()
	
	

func _find_all_level_packs():
	var levels_json = Globals.LEVELS_PATH + "/levels.json"
	var file = File.new()
	file.open(levels_json, File.READ)
	var levels_data = JSON.parse(file.get_as_text())
	file.close()
	assert(true, typeof(levels_data.result) == TYPE_ARRAY)
	for level_pack in levels_data.result:
		var level_pack_info = LevelPackInfo.new(
			level_pack["name"],
			Globals.LEVELS_PATH + "/" + level_pack["file_name"],
			level_pack.get("author", ""),
			level_pack["number_of_levels"]
			)
		level_packs[level_pack_info.name] = level_pack_info
