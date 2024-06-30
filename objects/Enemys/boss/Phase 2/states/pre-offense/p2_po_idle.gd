extends State
class_name p2_po_idle

@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]


func Enter():
	enemy.idle_direction = enemy.change_idle_dir()


func Update(_delta):
	if $"../../dash_cooldown".is_stopped() and $"../../attack_cooldown".is_stopped():
		Transitioned.emit(self, "p2_o_start_attack")


func Physics_Update(_delta):
	enemy.velocity = (player.global_position-enemy.global_position
	).rotated(deg_to_rad(90*enemy.idle_direction)).normalized()*enemy.speed/4
