extends Node


var part_sprite = null
var title = "Double attack speed"
var discription = """Doubles your attack speed"""


func affect(entity):
	entity.attack_cooldown = round(entity.attack_cooldown/2)
