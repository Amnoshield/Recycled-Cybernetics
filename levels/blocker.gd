extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Tracker.end = self


func open():
	$"../open".play("open")
	$"../AudioStreamPlayer".play()
	self.queue_free()
