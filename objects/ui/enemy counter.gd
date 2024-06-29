extends Label


func _ready():
	Tracker.enemy_counter = self
	change_label(Tracker.num_enemies)


func change_label(num:int):
	text = "Enemies left: {0}".format([num])


