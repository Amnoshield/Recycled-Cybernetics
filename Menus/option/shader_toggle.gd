extends OptionButton


func _ready():
	draw.connect(drawn)
	pressed.connect(clicked)

func _on_item_selected(index: int) -> void:
	GlobalAudio.click()
	match index:
		0:
			CRT_Shader.visible = true
		1:
			CRT_Shader.visible = false


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
