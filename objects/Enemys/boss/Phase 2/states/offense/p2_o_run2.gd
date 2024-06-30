extends State
class_name p2_o_run2


@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
var rng = RandomNumberGenerator.new()


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	enemy.velocity = (player.global_position - enemy.global_position).normalized()*enemy.speed
	
	if  nav.distance_to_target() < 40:
		Transitioned.emit(self, "p2_o_attack2")


