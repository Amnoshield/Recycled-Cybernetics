extends State
class_name Fighter_Idle

@onready var enemy:CharacterBody2D = $"../.."
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var ray:RayCast2D = $"../../RayCast2D"


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	ray.target_position = player.global_position-enemy.global_position
	ray.force_raycast_update()
	if ray.is_colliding() or nav.distance_to_target() > enemy.wait_distence+enemy.wiggle_room:
		enemy.idle_direction*=-1
		Transitioned.emit(self, "Fighter_pathfind")
	elif nav.distance_to_target() < enemy.wait_distence-enemy.wiggle_room:
		Transitioned.emit(self, "Fighter_walk_away")
	
	enemy.velocity = (player.global_position-enemy.global_position).rotated(deg_to_rad(90*enemy.idle_direction)).normalized()*enemy.idle_speed
