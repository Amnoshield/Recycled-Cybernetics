extends Node


var part_sprite = "res://assets/ui/abilities/wrench.png"
var title = "Halfs dash cooldown"
var discription = """Dash more often"""
var background_sprite = null


func affect(entity):
	entity.dash_cooldown /= 2
