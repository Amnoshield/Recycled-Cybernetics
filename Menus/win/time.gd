extends ReferenceRect

var minutes:int = 0
var seconds: int = 0
var mseconds: int = 0


func _ready() -> void:
	mseconds = fmod(SpeedrunTimer.time, 1) * 100
	seconds = fmod(SpeedrunTimer.time, 60)
	minutes = fmod(SpeedrunTimer.time, 3600) / 60
	
	$HBoxContainer/min.text = "%02d:" % minutes
	$HBoxContainer/sec.text = "%02d." % seconds
	$HBoxContainer/msec.text = "%03d" % mseconds
