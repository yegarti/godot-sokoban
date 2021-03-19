extends MarginContainer

signal change_scene(scene_type)

var _version

func _ready():
	var file = File.new()
	file.open("res://version.txt", File.READ)
	_version = file.get_line()
	file.close()
	$VBoxContainer/VersionLabel.text = 'v' + _version
	$VBoxContainer/HBoxContainer/MenuContainer/VBoxContainer/Play.grab_focus()


func _on_Exit_pressed():
	emit_signal("change_scene", Globals.SceneType.Quit)

func _on_Help_pressed():
	emit_signal("change_scene", Globals.SceneType.Help)

func _on_Play_pressed():
	emit_signal("change_scene", Globals.SceneType.SelectPack)
