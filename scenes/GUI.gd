extends CanvasLayer

onready var help_button := $Control/MarginContainer/Elements/HBoxContainer/HBoxLeft/HelpButton
onready var reset_button = $Control/MarginContainer/Elements/HBoxContainer/HBoxLeft/ResetButton
onready var prev_level_button = $Control/MarginContainer/Elements/HBoxContainer/HBoxLeft/PrevLevelButton
onready var next_level_button = $Control/MarginContainer/Elements/HBoxContainer/HBoxLeft/NextLevelButton
onready var menu_button = $Control/MarginContainer/Elements/HBoxContainer/HBoxLeft/MenuButton
onready var level_name_label = $Control/MarginContainer/Elements/HBoxContainer/HBoxMiddle/VBoxLevelInfo/LevelNameContainer/LevelLabel
onready var level_name_checkmark = $Control/MarginContainer/Elements/HBoxContainer/HBoxMiddle/VBoxLevelInfo/LevelNameContainer/LevelCheckmark
onready var moves_label = $Control/MarginContainer/Elements/HBoxContainer/HBoxMiddle/MovesContainer/MovesLabel
onready var pushes_label = $Control/MarginContainer/Elements/HBoxContainer/HBoxMiddle/PushesContainer/PushesLabel
onready var level_pack_name_label = $Control/MarginContainer/Elements/HBoxContainer/HBoxMiddle/VBoxLevelInfo/LevelPackLabel
onready var level_completed_message = $Control/LevelCompletedMessage
onready var help_menu = $Control/Instructions

const LEVEL_COMPLETED_TWEEN_DURATION = 1

func _ready():
	help_button.connect("pressed", self, "_send_input_action", ["ui_help"])
	reset_button.connect("pressed", self, "_send_input_action", ["ui_reset"])
	prev_level_button.connect("pressed", self, "_send_input_action", ["ui_prev_level"])
	next_level_button.connect("pressed", self, "_send_input_action", ["ui_next_level"])
	menu_button.connect("pressed", self, "_send_input_action", ["ui_back"])

func show():
	$Control.visible = true

func hide():
	$Control.visible = false


func set_level_name(name):
	level_name_label.text = name

func set_level_pack_name(name):
	level_pack_name_label.text = name

func set_pushes(new_pushes):
	pushes_label.text = "Pushes\n" + str(new_pushes)
	
func set_moves(new_moves):
	moves_label.text = "Moves\n" + str(new_moves)

func _send_input_action(action):
	var ev = InputEventAction.new()
	ev.action = action
	
	ev.pressed = true
	Input.parse_input_event(ev)
	ev.pressed = false
	Input.parse_input_event(ev)

func get_size():
	return Vector2($Control/MarginContainer.rect_size.x, $Control/MarginContainer.rect_size.y)

func show_level_completed_mark():
	self.level_name_checkmark.visible = true

func hide_level_completed_mark():
	self.level_name_checkmark.visible = false
	
func show_level_completed_label(slow = false):
	self.level_completed_message.show_msg(Globals.LVL_DONE_MESSAGE_VISIBLE_TIME if slow else 0)

func hide_level_completed_label(slow = false):
	self.level_completed_message.hide_msg(Globals.LVL_DONE_MESSAGE_VISIBLE_TIME if slow else 0)

func show_help_menu():
	self.help_menu.visible = true

func hide_help_menu():
	self.help_menu.visible = false


func _on_HelpButton_pressed():
	pass # Replace with function body.
