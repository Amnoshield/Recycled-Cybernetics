extends simpleButton

func _ready() -> void:
	super()
	var record_file = "user://easy_record.save"
	if FileAccess.file_exists(record_file):
		var read_file = FileAccess.open(record_file, FileAccess.READ)
		var best_time = read_file.get_var()["time"]
		read_file.close()
		
		var mseconds = fmod(best_time, 1) * 100
		var seconds = fmod(best_time, 60)
		var minutes = fmod(best_time, 3600) / 60
		
		text = "Easy\n" + "Best Time: " + "%02d:" % minutes + "%02d." % seconds + "%03d" % mseconds
		$Panel.visible = true
	
	else:
		text = "Easy"
		$Panel.visible = false

func _on_pressed():
	Tracker.difficulty = "easy"
	Tracker.reset()
	get_tree().change_scene_to_file(Tracker.totorial_level)
