extends Button

var hovered = false

func _on_pressed():
	Tracker.difficulty = "hard"
	Tracker.reset()
	get_tree().change_scene_to_file(Tracker.totorial_level)


func _on_draw():
	if disabled:
		return
	
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif is_hovered() and hovered:
		$"../../click".play()
	elif not is_hovered() and hovered:
		hovered = false
