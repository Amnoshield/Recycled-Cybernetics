extends Node


var part_sprite = "res://assets/ui/abilities/circut board.png"
var title = "Half attack speed"
var discription = """Halfs your attack speed"""
var background_sprite = null


func affect(entity):
	entity.attack_cooldown *= 2
