extends Node


var part_sprite = "res://assets/ui/abilities/circut board.png"
var title = "Half Health"
var discription = """Halfs your health"""
var background_sprite = null


func affect(entity):
	entity.health = round(entity.health/2)
	entity.max_health = round(entity.max_health/2)
