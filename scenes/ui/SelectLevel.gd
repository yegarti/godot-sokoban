extends MarginContainer

onready var levels_container = $VBoxContainer/LevelsContainer/GridContainer
signal change_scene(scene_type)

const TAG = "LevelSelect"

var _level_status_to_color = {
	UserData.LevelStatus.New: "blue",
	UserData.LevelStatus.Finished: "green",
}

var _button_size = Vector2(60, 60)

func _ready():
	if not Globals.current_level_pack:
		for i in range(20):
			_create_new_button(str(i+1))
	else:
		$VBoxContainer/TitleLabel.text = "%s Levels" % Globals.current_level_pack.name
		if Globals.current_level_pack.author:
			$VBoxContainer/AuthorLabel.text = "Author: %s" % Globals.current_level_pack.author
		else:
			$VBoxContainer/AuthorLabel.text = "  "
		for i in range(Globals.current_level_pack.number_of_levels):
			_create_new_button(i)
	if levels_container.get_child_count() > 0:
		levels_container.get_child(0).grab_focus()


func _create_new_button(lvl_id):
	var button = Button.new()
	var button_color = _level_status_to_color[UserData.LevelStatus.New]
	
	# no global variable when running scene as stand alone
	if Globals.current_level_pack:
		var level_status = UserData.get_level_data(Globals.current_level_pack.id, lvl_id)['status']
		button_color = _level_status_to_color[level_status]

	Globals.set_button_style(button, button_color)

	button.rect_min_size = _button_size
	button.text = str(lvl_id + 1)
	button.connect("pressed", self, "_load_selected_level", [lvl_id])
	levels_container.add_child(button)
	


func _load_selected_level(lvl_id):
	Logger.info("Loading level: '%d'" % lvl_id, TAG)
	Globals.current_level_id = lvl_id
	emit_signal("change_scene", Globals.SceneType.Game)
