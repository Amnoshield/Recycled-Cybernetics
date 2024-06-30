extends State
class_name p2_d_run

@onready var run_timer = $"../run_timer"
@onready var ray:RayCast2D = $"../../RayCast2D"
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]

func Enter():
	run_timer.start()


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	ray.target_position = player.global_position-enemy.global_position
	ray.force_raycast_update()
	if  nav.distance_to_target() > 300:
		Transitioned.emit(self, "p2_d_idle")

	enemy.velocity = (enemy.global_position-player.global_position).normalized()*enemy.speed


func _on_run_timer_timeout():
	if $"..".current_state == self:
		Transitioned.emit(self, "p2_d_idle")
