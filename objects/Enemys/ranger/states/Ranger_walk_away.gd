extends State
class_name Ranger_walk_away

@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var attack_cooldown:Timer = $"../../attack_cooldown"


func Physics_Update(_delta):
	nav.set_target_position(player.global_position)
	if  nav.distance_to_target() > enemy.wait_distence:
		Transitioned.emit(self, "ranger_idle")
	elif attack_cooldown.is_stopped():
		Transitioned.emit(self, "Ranger_Attack")

	enemy.velocity = (enemy.global_position-player.global_position).normalized()*enemy.walk_speed
