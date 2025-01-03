extends ReferenceRect

var minutes:int = 0
var seconds: int = 0
var mseconds: int = 0

var new_pb = false
var color_hue = 0


func _ready() -> void:
	@warning_ignore("narrowing_conversion")
	mseconds = fmod(SpeedrunTimer.time, 1) * 100
	@warning_ignore("narrowing_conversion")
	seconds = fmod(SpeedrunTimer.time, 60)
	@warning_ignore("narrowing_conversion")
	minutes = fmod(SpeedrunTimer.time, 3600) / 60
	
	$HBoxContainer/min.text = "%02d:" % minutes
	$HBoxContainer/sec.text = "%02d." % seconds
	$HBoxContainer/msec.text = "%03d" % mseconds
	
	if SpeedrunTimer.new_pb or true:
		new_pb = true
		$HBoxContainer/time.text = "New PB! "
		modulate = Color("0ff")
	else:
		$HBoxContainer/time.text = "In: "


func _process(_delta: float) -> void:
	if new_pb:
		modulate = Color.from_hsv(color_hue, 1, 1)
		color_hue += 0.002

		if color_hue > 1:
			color_hue = 0
