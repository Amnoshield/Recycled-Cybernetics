extends State
class_name fighter_attack

@onready var enemy:CharacterBody2D = $"../.."
@onready var attack_hitbox = $"../../attack_box/CollisionShape2D"

func Enter():
	attack_hitbox.disabled = false
	enemy.attacking_frame = 0

func Physics_Update(_delta):
	if enemy.attacking_frame >= enemy.attacking_frames-1:
		$"../../attack_cooldown".start()
		attack_hitbox.disabled = true
		
		Transitioned.emit(self, "Fighter_Idle")
	
	enemy.attacking_frame += 1
	enemy.velocity = enemy.attacking_velocity


func Knockback_Event():
	pass
