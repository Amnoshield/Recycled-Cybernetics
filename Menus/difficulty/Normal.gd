extends Button

@export var click_sound:AudioStreamPlayer
@export var sfx_sound:AudioStreamPlayer

var hovered = false

func _ready() -> void:
	var record_file = "user://normal_record.save"
	if FileAccess.file_exists(record_file): # and not disabled??????
		var read_file = FileAccess.open(record_file, FileAccess.READ)
		var best_time = read_file.get_var()["time"]
		read_file.close()
		
		var mseconds = fmod(best_time, 1) * 100
		var seconds = fmod(best_time, 60)
		var minutes = fmod(best_time, 3600) / 60
		
		text = "Normal\n" + "Best Time: " + "%02d:" % minutes + "%02d." % seconds + "%03d" % mseconds
		$Panel.visible = true
	
	else:
		text = "Normal"
		$Panel.visible = false


func _on_pressed():
	Tracker.difficulty = "normal"
	Tracker.reset()
	get_tree().change_scene_to_file(Tracker.totorial_level)


func _on_draw():
	if disabled:
		return
	
	if is_hovered() and not hovered:
		hovered = true
		sfx_sound.play()
	elif is_hovered() and hovered:
		click_sound.play()
	elif not is_hovered() and hovered:
		hovered = false
