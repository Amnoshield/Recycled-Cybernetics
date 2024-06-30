extends TextureProgressBar

@onready var cooldown = $"../../../../Dash/cooldown"


func setup():
	max_value = cooldown.wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = max_value-cooldown.time_left
	if modulate.a == 1 and value != max_value:
		modulate.a = 0.5
	elif modulate.a != 1 and value == max_value:
		modulate.a = 1
