extends Label


func start():
	Tracker.enemy_counter = self


func change_label(num:int):
	text = "Enemies left: {0}".format([num])


