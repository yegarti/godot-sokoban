extends MarginContainer

onready var levels_container = $VBoxContainer/LevelsContainer/GridContainer
signal change_scene(scene_type)

const TAG = "LevelSelect"


var _button_font_style = preload("res://styles/font_button.tres")
var _button_styles = {
	"new": {
		"normal": preload("res://styles/style_button_normal.tres"),
		"hover": preload("res://styles/style_button_hover.tres"),
		"pressed": preload("res://styles/style_button_pressed.tres"),
	},
	"done": {
	}
}
var _button_size = Vector2(60, 60)

func _ready():
	if not Globals.current_level_pack:
		for i in range(20):
			_create_new_button(str(i+1), "new")
	else:
		$VBoxContainer/TitleLabel.text = "%s Levels" % Globals.current_level_pack.name
		if Globals.current_level_pack.author:
			$VBoxContainer/AuthorLabel.text = "Author: %s" % Globals.current_level_pack.author
		else:
			$VBoxContainer/AuthorLabel.text = "  "
		for i in range(Globals.current_level_pack.number_of_levels):
			_create_new_button(i+1, "new")


func _create_new_button(lvl_id, state):
	var button = Button.new()
	for style_name in _button_styles[state]:
		button.set('custom_styles/%s' % style_name, _button_styles[state][style_name])
	button.set('custom_fonts/font', _button_font_style)
	button.rect_min_size = _button_size
	button.text = str(lvl_id)
	button.connect("button_down", self, "_load_selected_level", [lvl_id])
	levels_container.add_child(button)

func _load_selected_level(lvl_id):
	Logger.info("Loading level: '%d'" % lvl_id, TAG)
	Globals.current_level_id = lvl_id - 1
	emit_signal("change_scene", Globals.SceneType.Game)
