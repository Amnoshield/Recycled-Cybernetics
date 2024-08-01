extends Area2D



func _on_parry_tracker_animation_finished(_anim_name):
	if not $"parry ani".is_playing():
		$Sprite2D.visible = false
