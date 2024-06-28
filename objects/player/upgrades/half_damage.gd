extends Node


var part_sprite = null
var title = "Half damage"
var discription = """Deal less damage"""
var background_sprite = null


func affect(entity):
	entity.damage /= 2
