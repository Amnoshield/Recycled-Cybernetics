extends simpleButton

func _on_toggled(toggled_on):
	#$"../credits".button_pressed = false
	#$"../credits/Panel".visible = false
	$Panel.visible = toggled_on
	set_pressed_no_signal(toggled_on)
