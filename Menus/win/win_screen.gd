extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	save_difficulty()
	SpeedrunTimer.save()
	$"you won".text = "You beat " + Tracker.difficulty + " mode"
	
	
func save_difficulty():
	if not FileAccess.file_exists("user://unlocks.save"):
		push_error("This shouldn't run, the file should have been created in the difficulty select screen")
		print("file not found {0}, making a new one".format(["user://unlocks.save"]))
		var save_file_write = FileAccess.open("user://unlocks.save", FileAccess.WRITE)
		save_file_write.store_8(1)
		save_file_write.close()
	
	var save_file = FileAccess.open("user://unlocks.save", FileAccess.READ)
	var defficulty_level = save_file.get_8()
	save_file.close()
	
	
	save_file = FileAccess.open("user://unlocks.save", FileAccess.WRITE)
	print(Tracker.difficulty, defficulty_level)
	if Tracker.difficulty == "easy" and defficulty_level == 1:
		save_file.store_8(2)
	elif Tracker.difficulty == "normal" and defficulty_level == 2:
		save_file.store_8(3)
	elif Tracker.difficulty == "hard" and defficulty_level == 3:
		save_file.store_8(4)
	
	save_file.close()
