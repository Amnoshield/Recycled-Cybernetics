extends Node


var part_sprite = "res://assets/ui/abilities/wrench.png" #The sprite for the part (idk how this will work)
var title = "Half knocback resistance"
var discription = """Take more knockback"""
var background_sprite = null #The sprite for the backround (idk how this will work)


func affect(entity): #applay the effect to the entity. ie: entity.damage /= 2
	entity.knockback_res = 2
