extends Button


var hovered = false


func _on_draw():
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif not is_hovered() and hovered:
		hovered = false


func _on_toggled(toggled_on):
	$"../credits".button_pressed = false
	$"../credits/Panel".visible = false
	$"./Panel".visible = toggled_on


func _on_pressed():
	$"../../click".play()
