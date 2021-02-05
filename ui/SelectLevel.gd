extends MarginContainer

onready var level_container = $VBoxContainer/CenterContainer/LevelContainer
var game_scene = preload("res://Game.tscn")

var level_button_scene = preload("res://ui/GameButton.tscn")

func _ready():
	for level_pack in Globals.level_packs:
		add_level(_get_level_pack_name(level_pack), level_pack)
	
func add_level(name, level_pack_path):
	var level_button = level_button_scene.instance()
	level_button.set_expand(true)
	level_button.set_custom_minimum_size(Vector2(1, 100))
	level_button.text = name
	#level_button.get_node("Text").get("custom_fonts/font").set_size(30)
	level_button.get_node("TextureButton").connect("button_down", self, "_load_level_action", [level_pack_path])
	level_container.add_child(level_button)

func _get_level_pack_name(level_pack_file):
		var lvl_name = level_pack_file.split('/')[-1].split('.')[0]
		lvl_name = lvl_name.replace('_', ' ')
		return lvl_name

func _load_level_action(level_file_name):
	queue_free()
	Logger.info("Loading level pack: " + level_file_name)

	Globals.curr_level_pack_file = level_file_name
	Globals.curr_level_pack_name = _get_level_pack_name(level_file_name).capitalize()
	get_tree().change_scene_to(game_scene)
