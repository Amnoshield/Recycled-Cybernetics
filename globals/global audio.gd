extends Node


func start_music():
	$"fighting music/blend".play("RESET")
	$"fighting music".play()

func end_music():
	$"fighting music/blend".play("audio end")
	

func _on_blend_animation_finished(anim_name):
	if anim_name == "audio end":
		$"fighting music".stop()

func click():
	$click.play()

func hover():
	$hover.play()
