extends Node


var part_sprite = "res://assets/ui/abilities/circut board.png"
var title = "Double attack speed"
var discription = """Doubles your attack speed"""
var background_sprite = null


func affect(entity):
	entity.attack_cooldown /= 2
