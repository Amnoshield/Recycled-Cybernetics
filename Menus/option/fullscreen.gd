extends OptionButton


func _ready():
	draw.connect(drawn)
	pressed.connect(clicked)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		selected = 1

func _on_item_selected(index: int) -> void:
	GlobalAudio.click()
	if index == 1:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

#sound
var hovered = false

func drawn():
	if is_hovered() and not hovered:
		hovered = true
		GlobalAudio.hover()
	elif not is_hovered() and hovered:
		hovered = false

func clicked():
	GlobalAudio.click()
