extends Node2D

var level = null
var level_id = 0
var level_scene = preload("res://objects/Level.tscn")
onready var level_parser = load("res://utils/LevelParser.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_new_level(level_id)

func _on_Level_completed():
	print("Good job!")

func _load_new_level(level_id: int):
	if level:
		level.queue_free()
	level = level_scene.instance()
	level.initialize(level_parser.get_level(level_id))
	add_child(level)
	level.connect("level_completed", self, "_on_Level_completed")
	$GUI.set_level_name("Level " + str(level_id + 1))

	$Camera2D.position = Vector2(level.width / 2, level.height / 2)

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit(0)
	elif event.is_action_pressed("ui_undo"):
		level.undo()
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
