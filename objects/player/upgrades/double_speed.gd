extends Node


var part_sprite = null #The sprite for the part (idk how this will work)
var title = "Double speed"
var discription = """Move faster"""
var background_sprite = null #The sprite for the backround (idk how this will work)


func affect(entity): #applay the effect to the entity. ie: entity.damage /= 2
	entity.speed *= 1.5

