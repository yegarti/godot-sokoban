extends CanvasLayer

onready var undo_button = $MarginContainer/Elements/HBoxContainer/UndoButton/TextureButton
onready var reset_button = $MarginContainer/Elements/HBoxContainer/ResetButton/TextureButton
onready var prev_level_button = $MarginContainer/Elements/HBoxContainer/PrevLevelButton/TextureButton
onready var next_level_button = $MarginContainer/Elements/HBoxContainer/NextLevelButton/TextureButton
onready var level_name_labe = $MarginContainer/Elements/HBoxContainer/LevelLabel
onready var level_completed_message = $LevelCompletedMessage

signal undo_pressed
signal reset_pressed

const LEVEL_COMPLETED_TWEEN_DURATION = 1

func _ready():
	undo_button.connect("button_down", self, "_send_input_action", ["ui_undo"])
	reset_button.connect("button_down", self, "_send_input_action", ["ui_reset"])
	prev_level_button.connect("button_down", self, "_send_input_action", ["ui_prev_level"])
	next_level_button.connect("button_down", self, "_send_input_action", ["ui_next_level"])

func set_level_name(name):
	level_name_labe.text = name

func _send_input_action(action):
	var ev = InputEventAction.new()
	ev.action = action
	
	ev.pressed = true
	Input.parse_input_event(ev)
	ev.pressed = false

func get_size():
	return Vector2($MarginContainer.rect_size.x, $MarginContainer.rect_size.y)

func show_level_completed_label(slow = false):
	self.level_completed_message.show_msg(self.LEVEL_COMPLETED_TWEEN_DURATION if slow else 0)

func hide_level_completed_label(slow = false):
	self.level_completed_message.hide_msg(self.LEVEL_COMPLETED_TWEEN_DURATION if slow else 0)
