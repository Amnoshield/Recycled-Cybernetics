extends Node


var part_sprite = null
var title = "Double dash cooldown"
var discription = """Dash less often"""
var background_sprite = null


func affect(entity):
	entity.dash_cooldown *= 2
