extends State
class_name p2_o_big_attack

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var enemy:CharacterBody2D = $"../.."
var rng = RandomNumberGenerator.new()
var relitive

func Enter():
	relitive = player.global_position-enemy.global_position
	$"../big attack".start()


func _on_big_attack_timeout():
	$"../../big attack".set_rotation(relitive.angle()+deg_to_rad(90))
	$"../../big attack/AnimationPlayer".play("big attack")
	
	if rng.randi_range(0, 1) == 1:
		Transitioned.emit(self, "p2_d_run")
	else:
		Transitioned.emit(self, "p2_po_idle")
