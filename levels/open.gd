extends AnimationPlayer



func _on_animation_finished(_anim_name):
	$"../AudioStreamPlayer".stop()
	$"../clank".play()
