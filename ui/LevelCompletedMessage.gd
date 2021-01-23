extends MarginContainer


func _tween_level_completed_label(start_visible, duration):
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate",
		Color(1, 1, 1, start_visible), Color(1, 1, 1, not start_visible), duration,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func show_msg(duration: int):
	_tween_level_completed_label(false, duration)

func hide_msg(duration: int):
	_tween_level_completed_label(true, duration)
