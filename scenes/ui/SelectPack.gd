extends MarginContainer

signal change_scene(scene_type)

onready var level_container = $VBoxContainer/ScrollContainer/CenterContainer/LevelContainer
const TAG = "SelectLevel"
var _button_size = Vector2(1, 60)

func _ready():
	for level_pack_info in Globals.level_packs.values():
		add_level_pack(level_pack_info)
	if level_container.get_child_count() > 0:
		level_container.get_child(0).grab_focus()

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

	Globals.set_button_style(button, "blue")

	button.rect_min_size = _button_size
	button.text = pack_info.name
	button.connect("pressed", self, "_load_level_action", [pack_info])
	level_container.add_child(button)
