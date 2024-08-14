extends Node


var part_sprite = "res://assets/ui/abilities/circut board.png"
var title = "Double Health"
var discription = """Doubles your max and current health"""
var background_sprite = null


func affect(entity):
	entity.health *=2
	entity.max_health *= 2
