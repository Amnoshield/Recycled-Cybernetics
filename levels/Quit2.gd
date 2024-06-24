extends Button


func _on_pressed():
	self.visible = false
	$"../Quit3".visible = true
