extends Button


func _on_pressed():
	get_tree().paused = false
	$"../..".queue_free()
