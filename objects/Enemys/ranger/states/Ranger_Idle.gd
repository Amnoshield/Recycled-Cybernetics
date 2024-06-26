extends State
class_name Ranger_Idle

@onready var enemy:CharacterBody2D = $"../.."
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var attack_cooldown:Timer = $"../../attack_cooldown"


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)

	if nav.distance_to_target() > enemy.wait_distence+enemy.wiggle_room:
		Transitioned.emit(self, "Ranger_pathfind")
	elif nav.distance_to_target() < enemy.wait_distence-enemy.wiggle_room:
		Transitioned.emit(self, "Ranger_walk_away")
	elif attack_cooldown.is_stopped():
		Transitioned.emit(self, "Ranger_Attack")
	
	enemy.velocity = (player.global_position-enemy.global_position).rotated(deg_to_rad(90*enemy.idle_direction)).normalized()*enemy.idle_speed
