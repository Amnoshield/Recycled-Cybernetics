extends Button


var hovered = false


func _on_draw():
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif not is_hovered() and hovered:
		hovered = false


func _on_toggled(toggled_on):
	$"../options".button_pressed = false
	$"../options/Panel".visible = false
	$Panel.visible = toggled_on
	set_pressed_no_signal(toggled_on)


func _on_pressed():
	$"../../click".play()
