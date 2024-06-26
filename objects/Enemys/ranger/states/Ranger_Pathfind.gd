extends State
class_name Ranger_Pathfind

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)

	if  nav.distance_to_target() < enemy.wait_distence:
		Transitioned.emit(self, "ranger_idle")

	var relitive_pos:Vector2 = nav.get_next_path_position()- enemy.global_position
	enemy.velocity = relitive_pos.normalized()*enemy.speed
