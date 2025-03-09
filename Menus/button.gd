extends Button
class_name simpleButton

var hovered = false

func _ready() -> void:
	draw.connect(drawn)
	pressed.connect(clicked)

func drawn():
	if disabled: return
	
	if is_hovered() and not hovered:
		hovered = true
		GlobalAudio.hover()
	elif not is_hovered() and hovered:
		hovered = false

func clicked():
	GlobalAudio.click()
