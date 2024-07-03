extends Node


var part_sprite = "res://assets/ui/abilities/circut board.png" #The sprite for the part (idk how this will work)
var title = "Less damage resistance"
var discription = """Take more damage"""
var background_sprite = null #The sprite for the backround (idk how this will work)


func affect(entity): #applay the effect to the entity. ie: entity.damage /= 2
	entity.damage_res = -1
