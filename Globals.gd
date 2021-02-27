extends Node

const TILE_SIZE = 64
const MOVE_DURATION = 0.03
const LVL_DONE_MESSAGE_VISIBLE_TIME = 1
const CONTINUES_MOVEMENT_DELAY = 0.2
const LEVELS_PATH = "res://levels/"
var current_level_pack
var current_level_id = 1

enum SceneType {SelectPack, Help, Quit, Main, SelectLevel, Game}

var _button_font_style = preload("res://styles/font_button.tres")
var _button_styles = {
		"normal": preload("res://styles/style_button_normal.tres"),
		"hover": preload("res://styles/style_button_hover.tres"),
		"pressed": preload("res://styles/style_button_pressed.tres"),
}
var _button_colors = {
	"blue": {
		"normal": {
			"bg_color": "26aee6",
			"border_color": "145b78",
		},
		"hover": {
			"bg_color": "1e7192",
			"border_color": "194354",
		},
		"pressed": {
			"bg_color": "26aee6",
			"border_color": "",
		}
	},
	"green": {
		"normal": {
			"bg_color": "22c43b",
			"border_color": "12681f",
		},
		"hover": {
			"bg_color": "1e9228",
			"border_color": "0f4914",
		},
		"pressed": {
			"bg_color": "22c43b",
			"border_color": "",
		}
	}
}
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
			level_pack["id"],
			level_pack["name"],
			Globals.LEVELS_PATH + "/" + level_pack["file_name"],
			level_pack.get("author", ""),
			level_pack["number_of_levels"])
		level_packs[level_pack_info.name] = level_pack_info


func set_button_style(button: Button, color: String):
	button.set('custom_fonts/font', _button_font_style)
	
	if not _button_colors.has(color):
		Logger.error("No button style for color: " + str(color))
		return

	for style_name in _button_colors[color]:
		var style_colors = _button_colors[color][style_name]
		var stbox = _button_styles[style_name].duplicate()
		if style_colors.has("bg_color"):
			stbox.set_bg_color(style_colors["bg_color"])
		if style_colors.has("border_color"):
			stbox.set_border_color(style_colors["border_color"])
		button.set('custom_styles/%s' % style_name, stbox)


# func set_label_style(label: Label, )
