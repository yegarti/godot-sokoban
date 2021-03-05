extends Node

const TILE_SIZE = 64
const MOVE_DURATION = 0.03
const LVL_DONE_MESSAGE_VISIBLE_TIME = 1
const CONTINUES_MOVEMENT_DELAY = 0.2
const LEVELS_PATH = "res://levels/"
const LEVELS_METADATA_JSON = "res://levels/levels.json"
const DEFAULT_LOG_LEVEL = Logger.DEBUG

enum SceneType {SelectPack, Help, Quit, Main, SelectLevel, Game}

var current_level_pack
var current_level_id = 1

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

func _ready():
	Logger.set_default_output_level(DEFAULT_LOG_LEVEL)

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
