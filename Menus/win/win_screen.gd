extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://unlocks.save"):
		print("file not found {0}, making a new one".format(["user://unlocks.save"]))
		var save_file_write = FileAccess.open("user://unlocks.save", FileAccess.WRITE)
		save_file_write.store_8(1)
		save_file_write.close()
	
	var save_file = FileAccess.open("user://unlocks.save", FileAccess.READ)
	var defficulty_level = save_file.get_8()
	save_file.close()
	
	
	save_file = FileAccess.open("user://unlocks.save", FileAccess.WRITE)
	if Tracker.difficulty == "easy" and defficulty_level == 1:
		save_file.store_8(2)
	elif Tracker.difficulty == "normal" and defficulty_level == 2:
		save_file.store_8(3)
	
	save_file.close()

