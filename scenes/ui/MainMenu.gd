extends MarginContainer

signal change_scene(scene_type)

func _ready():
	$VBoxContainer/MenuContainer/VBoxContainer/Play.grab_focus()


func _on_Exit_pressed():
	emit_signal("change_scene", Globals.SceneType.Quit)

func _on_Help_pressed():
	emit_signal("change_scene", Globals.SceneType.Help)

func _on_Play_pressed():
	emit_signal("change_scene", Globals.SceneType.SelectPack)
