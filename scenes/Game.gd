extends Node2D

signal change_scene(scene_type)

var level = null
var level_id = 0
var level_scene = preload("res://objects/Level.tscn")
var level_completed = false
var level_data
onready var level_parser = load("res://utils/LevelParser.gd").new()
const TAG = "Game"

var help_menu_is_shown = false
var _delay_from_last_undo = 0

onready var width = get_viewport().size.x
onready var height = get_viewport().size.y
onready var visible_height = height - $GUI.get_size().y

func _ready():
	_load_new_level(Globals.current_level_id)

func _on_Level_completed():
	if not level_completed:
		level_completed = true
		$GUI.show_level_completed_label(true)
		$GUI.show_level_completed_mark()
		Logger.info("Level completed!", TAG)
		var moves = level.get_stats()['moves']
		if moves < level_data['score']:
			$GUI.set_high_score(moves)
		UserData.set_level_data(Globals.current_level_pack.id,
								level_id,
								UserData.LevelStatus.Finished,
								moves)
		UserData.save_game()

func _load_new_level(lvl_id: int):
	self.level_id = lvl_id
	level_data = UserData.get_level_data(Globals.current_level_pack.id, level_id)
	$GUI.show()
	if level:
		level.queue_free()
	level = level_scene.instance()
	level.initialize(level_parser.get_level(level_id))
	add_child(level)
	level.connect("level_completed", self, "_on_Level_completed")
	$GUI.set_level_name("Level " + str(lvl_id + 1))
	$GUI.set_level_pack_name(Globals.current_level_pack.name)
	$GUI.hide_level_completed_label()
	if level_data['status'] == UserData.LevelStatus.Finished:
		$GUI.show_level_completed_mark()
		if level_data.has('score'):
			$GUI.set_high_score(level_data['score'])
	else:
		$GUI.hide_level_completed_mark()
		$GUI.hide_high_score()
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

func _adjust_camera():
	$Camera2D.position = Vector2(level.width / 2, (level.height - (self.height - self.visible_height)) / 2)
	var zoom_scale = max(max(level.width / self.width, 1),
						 (max(level.height / self.visible_height, 1)))
	$Camera2D.zoom = Vector2.ONE * zoom_scale

func _load_main_menu():
	Logger.info("Changing scene to main menu")
	emit_signal("change_scene", Globals.SceneType.Main)
