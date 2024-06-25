extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Tracker.end = self


func open():
	self.queue_free()
