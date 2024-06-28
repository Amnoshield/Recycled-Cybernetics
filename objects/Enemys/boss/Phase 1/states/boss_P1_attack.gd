extends State
class_name boss_P1_attack

@onready var enemy:CharacterBody2D = $"../.."


func Physics_Update(_delta):
	if enemy.attacking_frame >= enemy.attacking_frames-1:
		Transitioned.emit(self, "boss_P1_Idle")
	
	enemy.attacking_frame += 1
	enemy.velocity = enemy.attacking_velocity
