extends Node
class_name State

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
