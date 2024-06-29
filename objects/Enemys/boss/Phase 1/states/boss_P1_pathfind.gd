extends State
class_name boss_P1_pathfind


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var attack_cooldown:Timer = $"../../attack_cooldown"
@onready var ray:RayCast2D = $"../../RayCast2D"


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	ray.target_position = player.global_position-enemy.global_position
	ray.force_raycast_update()
	if  not ray.is_colliding() and nav.distance_to_target() < enemy.wait_distence:
		Transitioned.emit(self, "boss_P1_idle")
	elif ray.is_colliding() and nav.path_postprocessing == 0:
		nav.path_postprocessing = 1
	elif not ray.is_colliding() and nav.path_postprocessing == 1:
		nav.path_postprocessing = 0

	var relitive_pos:Vector2 = nav.get_next_path_position()- enemy.global_position
	enemy.velocity = relitive_pos.normalized()*enemy.speed
