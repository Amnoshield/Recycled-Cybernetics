extends State
class_name p2_o_run

@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var rng = RandomNumberGenerator.new()


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	if  nav.distance_to_target() > 60:
		if rng.randi_range(0, 1) == 1:
			Transitioned.emit(self, "p2_d_run")
		else:
			Transitioned.emit(self, "p2_po_idle")

	enemy.velocity = (enemy.global_position-player.global_position).normalized()*enemy.speed
