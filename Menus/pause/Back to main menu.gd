extends Button


var hovered = false


func load_main_menu():
	get_tree().change_scene_to_file("res://Menus/main/main_menu.tscn")


func _on_pressed():
	load_main_menu()


func _on_exit_pressed():
	load_main_menu()


func _on_draw():
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif is_hovered() and hovered:
		$"../../click".play()
	elif not is_hovered() and hovered:
		hovered = false



