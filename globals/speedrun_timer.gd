extends Node

var timer
var time: float = 0.0
var splits:Array = []
var last_split: float = 0.0
var new_pb = false


func start_timer():
	timer.start()


func new_split():
	splits.append(time)
	
	var record_file = "user://"+Tracker.difficulty+"_record.save"
	if FileAccess.file_exists(record_file):
		var read_file = FileAccess.open(record_file, FileAccess.READ)
		var old_splits = read_file.get_var()["splits"]
		
		var old_split = old_splits[len(splits)-1]
		last_split = time-old_split
		
		read_file.close()


func save():
	var record_file = "user://"+Tracker.difficulty+"_record.save"
	
	if not FileAccess.file_exists(record_file):
		push_warning("File did not exsist, creating a new one: " + record_file)
		
		new_pb = true
		
		var save_file = FileAccess.open(record_file, FileAccess.WRITE)
		save_file.store_var({"splits":splits, "time":time})
		save_file.close()
	else:
		var read_file = FileAccess.open(record_file, FileAccess.READ)
		var old_time = read_file.get_var()["time"]
		read_file.close()
		
		if time < old_time:
			new_pb = true
			var save_file = FileAccess.open(record_file, FileAccess.WRITE)
			
			save_file.store_var({"splits":splits, "time":time})
			save_file.close()


func reset():
	time = 0.0
	splits = []
	last_split = 0.0
	new_pb = false
