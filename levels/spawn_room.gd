extends Area2D


func _on_area_exited(area):
	print(area.name)
	$"../blocker".translate(Vector2(0, -96))
