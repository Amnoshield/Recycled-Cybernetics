extends simpleButton


func _on_pressed() -> void:
	$"../../AnimationPlayer".play("options")
