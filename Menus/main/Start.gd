extends Button

@export var difficulty : PackedScene
var hovered = false

func _on_pressed():
	get_tree().change_scene_to_packed(difficulty)


func _on_draw():
	if is_hovered() and not hovered:
		hovered = true
		$"../../sfx".play()
	elif is_hovered() and hovered:
		$"../../click".play()
	elif not is_hovered() and hovered:
		hovered = false
