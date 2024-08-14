extends State
class_name p2_knockback

@onready var enemy:CharacterBody2D = $"../.."
@export var idle = "p2_d_idle"
var rng = RandomNumberGenerator.new()


func Physics_Update(_delta):
	enemy.knockback = enemy.knockback.limit_length(enemy.knockback.length())
	enemy.velocity = enemy.knockback
	enemy.knockback /= 2
	
	if enemy.knockback.length() < enemy.speed:
		if enemy.state == 'd':
			Transitioned.emit(self, idle)
		elif enemy.state == "po":
			Transitioned.emit(self, "p2_po_pathfind")
		else:
			if enemy.state != "o":
				print("what the fwek")
			
			if rng.randi_range(0, 1) == 1:
				Transitioned.emit(self, "p2_d_run")
			else:
				Transitioned.emit(self, "p2_po_idle")
