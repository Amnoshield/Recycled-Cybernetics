extends Node


var part_sprite = null
var title = "Double Health"
var discription = """Doubles your max and current health
(You will keep your health percentage)"""
var background_sprite = null


func affect(entity):
	entity.health *=2
	entity.max_health *= 2
