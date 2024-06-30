extends State
class_name p2_o_attack1

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var enemy:CharacterBody2D = $"../.."

func Enter():
	var relitive = player.global_position-enemy.global_position
	$"../../attack_box".set_rotation(relitive.angle()+deg_to_rad(90))
	$"../../attack_box/AnimationPlayer".play("sword attack")
	$"../../attack_cooldown".start()
	Transitioned.emit(self, "p2_o_run")
