extends MarginContainer

onready var level_container = $VBoxContainer/ScrollContainer/CenterContainer/LevelContainer
const TAG = "SelectLevel"
var select_level_scene = preload("res://ui/LevelSelect.tscn")
var level_button_scene = preload("res://ui/GameButton.tscn")

func _ready():
	for level_pack_info in Globals.level_packs.values():
		add_level_pack(level_pack_info)

func add_level_pack(level_pack_info):
	Logger.debug("Adding level pack '%s' with %d levels at %s" % 
		[level_pack_info.name, level_pack_info.number_of_levels, level_pack_info.path], TAG)
	var level_button = level_button_scene.instance()
	level_button.set_expand(true)
	level_button.set_custom_minimum_size(Vector2(250, 57))
	level_button.text = level_pack_info.name
	level_button.get_node("TextureButton").connect("button_down", self,
		"_load_level_action", [level_pack_info])
	level_container.add_child(level_button)

func _load_level_action(level_pack_info):
	queue_free()
	Logger.info("Loading level pack: '%s'" % level_pack_info.name, TAG)
	Globals.current_level_pack = level_pack_info
	get_tree().change_scene_to(select_level_scene)
