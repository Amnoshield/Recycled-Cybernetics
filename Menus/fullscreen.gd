extends CheckBox


func _ready():
	button_pressed = DisplayServer.window_get_mode()


func _on_toggled(toggled_on):
	$"../click".play()
	if toggled_on:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if not toggled_on:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
