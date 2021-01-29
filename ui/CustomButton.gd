extends MarginContainer

class_name CustomButton

export (String) var text = "" setget set_text

func _ready():
	pass

func set_text(text):
	if not is_inside_tree(): yield(self, 'ready')
	$Text.text = text

func set_expand(expand):
	$TextureButton.expand = expand
