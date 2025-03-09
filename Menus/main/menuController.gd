extends AnimationPlayer

func _on_credits_pressed() -> void:
	play("credits")

func _on_creditmain_pressed() -> void:
	play("credit->main")


func _on_options_pressed() -> void:
	play("options")


func _on_optionsmain_pressed() -> void:
	play("options->main")


func _on_start_pressed() -> void:
	play("chooseDifficulty")
