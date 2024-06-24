extends Area2D


func _on_area_exited(_area):
	$"../blocker".translate(Vector2(0, -96))
	Tracker.spawn_enemies()
