extends Node


var part_sprite = null
var title = "Double parry cooldown"
var discription = """Parry less often """
var background_sprite = null


func affect(entity):
	entity.parry_cooldown *= 2
