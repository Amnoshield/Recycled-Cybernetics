extends TextureProgressBar


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]


func setup():
	max_value = player.dash_timer.wait_time
	value = player.dash_timer.time_left

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = max_value-player.dash_timer.time_left
	


func _on_value_changed(da_value):
	if da_value == max_value:
		modulate.a = 1
	else:
		modulate.a = 0.5
