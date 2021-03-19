extends MarginContainer

signal change_scene(scene_type)

onready var level_container = $VBoxContainer/ScrollContainer/CenterContainer/LevelContainer
const TAG = "SelectLevel"
var _button_size = Vector2(1, 60)
var level_packs = {}

func _ready():
	_find_all_level_packs()
	for level_pack_info in level_packs.values():
		add_level_pack(level_pack_info)

	Globals.current_level_id = 0
	if Globals.current_level_pack:
		level_container.get_node(Globals.current_level_pack.id).grab_focus()
	else:
		level_container.get_child(0).grab_focus()

func _find_all_level_packs():
	var levels_json = Globals.LEVELS_METADATA_JSON
	var file = File.new()
	file.open(levels_json, File.READ)
	var levels_data = JSON.parse(file.get_as_text())
	file.close()
	assert(true, typeof(levels_data.result) == TYPE_ARRAY)
	for level_pack in levels_data.result:
		if level_pack['enabled']:
			var level_pack_info = LevelPackInfo.new(
				level_pack["id"],
				level_pack["name"],
				Globals.LEVELS_PATH + level_pack["file_name"],
				level_pack.get("author", ""),
				level_pack["number_of_levels"])
			level_packs[level_pack_info.name] = level_pack_info

func add_level_pack(level_pack_info):
	Logger.debug("Adding level pack '%s' with %d levels at %s" % 
		[level_pack_info.name, level_pack_info.number_of_levels, level_pack_info.path], TAG)
	_create_new_button(level_pack_info)

func _load_level_action(level_pack_info):
	queue_free()
	Logger.info("Loading level pack: '%s'" % level_pack_info.name, TAG)
	Globals.current_level_pack = level_pack_info
	emit_signal("change_scene", Globals.SceneType.SelectLevel)

func _create_new_button(pack_info: LevelPackInfo):
	var button = Button.new()
	button.name = pack_info.id

	Globals.set_button_style(button, "blue")

	button.rect_min_size = _button_size
	button.text = pack_info.name
	button.connect("pressed", self, "_load_level_action", [pack_info])
	level_container.add_child(button, true)
