extends HSlider

var master_bus = AudioServer.get_bus_index("Master")

func _ready():
	value = AudioServer.get_bus_volume_db(master_bus)

func _on_value_changed(value_):
	if fmod(value_, 3) == 0:
		$"../click".play()
	
	AudioServer.set_bus_volume_db(master_bus, value_)
	
	
	if value_ == -30:
		AudioServer.set_bus_mute(master_bus, true)
	else:
		AudioServer.set_bus_mute(master_bus, false)
