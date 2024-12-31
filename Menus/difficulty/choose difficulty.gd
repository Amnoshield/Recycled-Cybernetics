extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if not FileAccess.file_exists("user://unlocks.save"):
		push_error("This should only run on first game load. It has been temporaraly disabled")
		
		#var save_file_write = FileAccess.open("user://unlocks.save", FileAccess.WRITE)
		#save_file_write.store_8(1)
		#save_file_write.close()
	
	
	var save_file = FileAccess.open("user://unlocks.save", FileAccess.READ)
	var defficulty_level = save_file.get_8()
	save_file.close()
	
	
	if defficulty_level == 0:
		push_error("This should not run")
		var save_file_write = FileAccess.open("user://unlocks.save", FileAccess.WRITE)
		save_file_write.store_8(1)
		save_file_write.close()
	

	if defficulty_level >= 2:
		$BoxContainer/Normal.disabled = false
	if defficulty_level >= 3:
		$BoxContainer/Hard.disabled = false
	if defficulty_level >= 4:
		$"BoxContainer/One shot".disabled = false
	
