extends ReferenceRect

var minutes:int = 0
var seconds: int = 0
var mseconds: int = 0

@export var label_current_min:Label
@export var label_current_sec:Label
@export var label_current_msec:Label

@export var label_split_plus:Label
@export var label_split_min:Label
@export var label_split_sec:Label
@export var label_split_msec:Label
@export var split_section:HBoxContainer


func _ready() -> void:
	stop()
	SpeedrunTimer.timer = self
	updateTimeDisplay()
	updateSplitDisplay()
	var record_file = "user://"+Tracker.difficulty+"_record.save"
	if not FileAccess.file_exists(record_file):
		visible = false


func _process(delta: float) -> void:
	SpeedrunTimer.time += delta
	updateTimeDisplay()


func updateTimeDisplay():
	@warning_ignore("narrowing_conversion")
	mseconds = fmod(SpeedrunTimer.time, 1) * 100
	@warning_ignore("narrowing_conversion")
	seconds = fmod(SpeedrunTimer.time, 60)
	@warning_ignore("narrowing_conversion")
	minutes = fmod(SpeedrunTimer.time, 3600) / 60
	
	label_current_min.text = "%02d:" % minutes
	label_current_sec.text = "%02d." % seconds
	label_current_msec.text = "%03d" % mseconds


func updateSplitDisplay():
	var last_split =  abs(SpeedrunTimer.last_split)
	@warning_ignore("narrowing_conversion")
	mseconds = fmod(last_split, 1) * 100
	@warning_ignore("narrowing_conversion")
	seconds = fmod(last_split, 60)
	@warning_ignore("narrowing_conversion")
	minutes = fmod(last_split, 3600) / 60
	
	label_split_min.text = "%02d:" % minutes
	label_split_sec.text = "%02d." % seconds
	label_split_msec.text = "%03d" % mseconds
	
	if SpeedrunTimer.last_split < 0:
		label_split_plus.text = "-"
	else:
		label_split_plus.text = "+"
	
	#color stuff
	if SpeedrunTimer.last_split == 0: #White
		split_section.modulate = Color("fff")
	elif SpeedrunTimer.last_split < -15: #Green
		split_section.modulate = Color("0f0")
	elif SpeedrunTimer.last_split < 0: #Lime
		split_section.modulate = Color("a3ff8d")
	elif SpeedrunTimer.last_split > 15: #Red
		split_section.modulate = Color("f00")
	elif SpeedrunTimer.last_split > 0: #Yellow ish
		split_section.modulate = Color("fc0")
		


func stop():
	set_process(false)


func start():
	set_process(true)
