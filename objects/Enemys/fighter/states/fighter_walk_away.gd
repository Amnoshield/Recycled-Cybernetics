extends State
class_name Fighter_walk_away


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var ray:RayCast2D = $"../../RayCast2D"
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var ap = $Sprite2D/AnimationPlayer

func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	ray.target_position = player.global_position-enemy.global_position
	ray.force_raycast_update()
	if  not ray.is_colliding() or nav.distance_to_target() > enemy.wait_distence:
		Transitioned.emit(self, "fighter_idle")

	enemy.velocity = (enemy.global_position-player.global_position).normalized()*enemy.walk_speed
