extends Button


func load_main_menu():
	get_tree().change_scene_to_file("res://Menus/main_menu.tscn")


func _on_pressed():
	load_main_menu()


func _on_exit_pressed():
	load_main_menu()
