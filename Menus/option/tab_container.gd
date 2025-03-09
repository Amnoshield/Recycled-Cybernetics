extends TabContainer


func _on_tab_hovered(tab: int) -> void:
	if tab != current_tab:
		GlobalAudio.hover()

func _on_tab_changed(_tab: int) -> void:
	GlobalAudio.click()
