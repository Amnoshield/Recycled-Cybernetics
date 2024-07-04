extends State
class_name p2_o_dash2

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var enemy:CharacterBody2D = $"../.."


func Enter():
	enemy.invincible = true
	enemy.dashing_frame = 0
	enemy.dashing_velocity = (enemy.global_position-player.global_position).normalized()*500


func Physics_Update(_delta):
	enemy.dashing_frame += 1
	enemy.velocity = enemy.dashing_velocity
	
	if enemy.dashing_frame >= enemy.dashing_frames -1: #Dash
		enemy.velocity = Vector2(0, 0)
		Transitioned.emit(self, "p2_o_big_attack")


func Exit():
	enemy.invincible = false
