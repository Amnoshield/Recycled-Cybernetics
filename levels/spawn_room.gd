extends Area2D


func _on_area_exited(_area):
	Tracker.start_level()
	SpeedrunTimer.start_timer()
	
	$"../blocker".translate(Vector2(0, -96))
	$"../AnimationPlayer".play("close")
	$"../AudioStreamPlayer".play()
	collision_mask = 0


func _on_animation_player_animation_finished(_anim_name):
	$"../AudioStreamPlayer".stop()
	$"../clank".play()
	GlobalAudio.start_music()
	
