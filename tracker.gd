extends Node

var num_enemies = 0
var enemies = []

func spawn_enemies():
	for enemy in enemies:
		enemy.spawnable = true
	enemies.clear()
