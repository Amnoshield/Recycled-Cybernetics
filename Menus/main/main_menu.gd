extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	Tracker.reset()
	GlobalAudio.end_music()
	