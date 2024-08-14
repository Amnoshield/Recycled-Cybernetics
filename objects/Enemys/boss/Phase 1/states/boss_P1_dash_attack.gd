extends State
class_name boss_P1_dash_attack

@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_hitbox = $"../../attack_box/CollisionShape2D"

func Enter():
	enemy.idle_direction = enemy.change_idle_dir()
	attack_hitbox.disabled = false
	enemy.attacking = true
	enemy.attacking_frame = 0
	enemy.attacking_velocity = (player.global_position-enemy.global_position)*enemy.speed/enemy.attacking_frames


func Physics_Update(_delta):
	if enemy.attacking_frame >= enemy.attacking_frames-1:
		attack_hitbox.disabled = true
		enemy.attacking = false
		Transitioned.emit(self, "boss_P1_Idle")
	
	enemy.attacking_frame += 1
	enemy.velocity = enemy.attacking_velocity


func Knockback_Event():
	pass
