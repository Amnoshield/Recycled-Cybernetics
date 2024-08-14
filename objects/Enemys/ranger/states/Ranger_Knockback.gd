extends State
class_name Ranger_Knockback

@onready var enemy:CharacterBody2D = $"../.."


func Physics_Update(_delta):
	enemy.knockback = enemy.knockback.limit_length(enemy.knockback.length()-enemy.knockback_res)
	enemy.velocity = enemy.knockback
	enemy.knockback /= 2
	
	if enemy.knockback.length() < enemy.speed:
		Transitioned.emit(self)
