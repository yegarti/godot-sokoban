extends Node2D

var level = null
var level_scene = preload("res://objects/Level.tscn")
onready var level_parser = load("res://utils/LevelParser.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	level = level_scene.instance()
	level.initialize(level_parser.parse_level(0))
	add_child(level)
	level.connect("level_completed", self, "_on_Level_completed")

func _on_Level_completed():
	print("Good job!")

func _unhandled_input(event):
	if event.is_action_pressed("quit"):
		get_tree().quit(0)
