extends State
class_name Blob_pathfind


@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var nav:NavigationAgent2D = $"../../NavigationAgent2D"
@onready var enemy:CharacterBody2D = $"../.."
@onready var attack_cooldown:Timer = $"../../attack_cooldown"


func Physics_Update(_delta):
	if not attack_cooldown.is_stopped():
		Transitioned.emit(self, "Blob_idle")
	nav.set_target_position(player.global_position)
	var relitive_pos:Vector2 = nav.get_next_path_position()- enemy.global_position
	enemy.velocity = relitive_pos.normalized()*enemy.speed
