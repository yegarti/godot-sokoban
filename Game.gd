extends Node2D
var main_menu_scene = load("res://ui/MainMenu.tscn")
var level = null
var level_id = 0
var level_scene = preload("res://objects/Level.tscn")
var level_completed = false
onready var level_parser = load("res://utils/LevelParser.gd").new()
const TAG = "Game"

var help_menu_is_shown = false
var _delay_from_last_undo = 0

onready var width = get_viewport().size.x
onready var height = get_viewport().size.y
onready var visible_height = height - $GUI.get_size().y

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_new_level(Globals.current_level_id)

func _on_level_pack_selected(level_pack):
	level_parser.set_level_pack(level_pack)
	_load_new_level(0)

func _on_Level_completed():
	if not level_completed:
		level_completed = true
		$GUI.show_level_completed_label(true)
		$GUI.show_level_completed_mark()
		Logger.info("Level completed!", TAG)

func _load_new_level(level_id: int):
	$GUI.show()
	if level:
		level.queue_free()
	level = level_scene.instance()
	level.initialize(level_parser.get_level(level_id))
	add_child(level)
	level.connect("level_completed", self, "_on_Level_completed")
	$GUI.set_level_name("Level " + str(level_id + 1))
	$GUI.set_level_pack_name(Globals.current_level_pack.name)
	$GUI.hide_level_completed_label()
	$GUI.hide_level_completed_mark()
	$GUI.hide_help_menu()
	level_completed = false
	_adjust_camera()

func _physics_process(delta):
	var stats = level.get_stats()
	_delay_from_last_undo += delta
	if Input.is_action_pressed("ui_undo") and _delay_from_last_undo > Globals.CONTINUES_MOVEMENT_DELAY:
		level.undo()
		_delay_from_last_undo = 0
	$GUI.set_moves(stats['moves'])
	$GUI.set_pushes(stats['pushes'])

func _unhandled_input(event):
	if event is InputEventKey and help_menu_is_shown:
		$GUI.hide_help_menu()
		help_menu_is_shown = false
	if event.is_action_pressed("quit"):
		get_tree().quit(0)
	if event.is_action_pressed("ui_help"):
		if not help_menu_is_shown:
			$GUI.show_help_menu()
			help_menu_is_shown = true
	elif event.is_action_pressed("ui_reset"):
		_load_new_level(level_id)
	elif event.is_action_pressed("ui_prev_level"):
		level_id -= 1
		if level_id < 0:
			level_id = level_parser.number_of_levels - 1
		_load_new_level(level_id)
	elif event.is_action_pressed("ui_next_level"):
		level_id = (level_id + 1) % level_parser.number_of_levels
		_load_new_level(level_id)
	elif event.is_action_pressed("ui_main_menu"):
		_load_main_menu()
		queue_free()

func _adjust_camera():
	$Camera2D.position = Vector2(level.width / 2, (level.height - (self.height - self.visible_height)) / 2)
	var zoom_scale = max(max(level.width / self.width, 1),
						 (max(level.height / self.visible_height, 1)))
	$Camera2D.zoom = Vector2.ONE * zoom_scale

func _load_main_menu():
	Logger.info("Changing scene to main menu")
	queue_free()
	get_tree().change_scene_to(main_menu_scene)
