extends Node
class_name State

@warning_ignore("unused_signal")
signal Transitioned
signal Overide

func Enter():
	pass
	
func Exit():
	pass

func Update(_delta):
	pass
	
func Physics_Update(_delta):
	pass

func Knockback_Event():
	Overide.emit(get_parent().knockback.name)
