extends Node


var part_sprite = null
var title = "Half Health"
var discription = """Halfs and then rounds your max and current health
(You will keep your health percentage)"""


func affect(entity):
	entity.health = round(entity.health/2)
	entity.max_health = round(entity.max_health/2)
