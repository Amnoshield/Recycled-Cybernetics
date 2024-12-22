extends Button

var hovered = false
@export_file(".tscn") var main_menu:String

func _on_draw():
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif is_hovered() and hovered:
		$"../../click".play()
	elif not is_hovered() and hovered:
		hovered = false


func _on_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)
