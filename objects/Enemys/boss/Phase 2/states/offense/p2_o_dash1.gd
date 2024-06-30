extends State
class_name p2_o_dash1

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var enemy:CharacterBody2D = $"../.."


func Enter():
	enemy.dashing_frame = 0
	enemy.dashing_velocity = (player.global_position-enemy.global_position).normalized()*500


func Physics_Update(_delta):
	enemy.dashing_frame += 1
	enemy.velocity = enemy.dashing_velocity
	
	if enemy.dashing_frame >= enemy.dashing_frames -1: #Dash
		Transitioned.emit(self, "p2_o_attack1")

