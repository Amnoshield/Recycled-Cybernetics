extends Node

var timer
var time: float = 0.0
var splits:Array = []


func start_timer():
	timer.start()


func new_split():
	var old_total = 0
	for t in splits:
		old_total += t
	splits.append(time-old_total)

	print(splits[-1])


func save():
	print(time)
	print(splits)
	var record_file = "user://"+Tracker.difficulty+"_record.save"
	
	if not FileAccess.file_exists(record_file):
		print("file not found {0}, making a new one".format([record_file]))
		var save_file = FileAccess.open(record_file, FileAccess.WRITE)
		save_file.store_var({"splits":splits, "time":time})
		save_file.close()
	else:
		var read_file = FileAccess.open(record_file, FileAccess.READ)
		var old_time = read_file.get_var()["time"]
		read_file.close()
		
		if old_time < time:
			var save_file = FileAccess.open(record_file, FileAccess.WRITE)
			
			save_file.store_var(splits)


func reset():
	time = 0.0
	splits = []
