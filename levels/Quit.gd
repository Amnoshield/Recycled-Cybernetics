extends Button


func _on_pressed():
	self.visible = false
	$"../../Quit2".visible = true
