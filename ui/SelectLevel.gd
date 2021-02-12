extends MarginContainer

onready var level_container = $VBoxContainer/ScrollContainer/CenterContainer/LevelContainer
const TAG = "SelectLevel"
var game_scene = preload("res://Game.tscn")

var level_button_scene = preload("res://ui/GameButton.tscn")

func _ready():
	for level_pack_info in Globals.level_packs:
		add_level_pack(level_pack_info)

func add_level_pack(level_pack_info):
	Logger.debug("Adding level pack '%s' with %d levels at %s" % 
		[level_pack_info.name, level_pack_info.number_of_levels, level_pack_info.path], TAG)
	var level_button = level_button_scene.instance()
	level_button.set_expand(true)
	level_button.set_custom_minimum_size(Vector2(250, 57))
	level_button.text = level_pack_info.name
	level_button.get_node("TextureButton").connect("button_down", self,
		"_load_level_action", [level_pack_info.name, level_pack_info.path])
	level_container.add_child(level_button)

func _load_level_action(level_pack_name, level_pack_path):
	queue_free()
	Logger.info("Loading level pack: '%s'" % level_pack_name, TAG)

	Globals.curr_level_pack_file = level_pack_path
	Globals.curr_level_pack_name = level_pack_name
	get_tree().change_scene_to(game_scene)
