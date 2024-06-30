extends State
class_name p2_d_idle

@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var parry_timer = $"../../player_range/parry_cooldown"
@onready var parry_der = $"../../player_range/parry_deration"
@onready var dash_timer = $"../../dash_cooldown"
@onready var feint_timer = $"../../feint"


func Physics_Update(_delta):
	enemy.velocity = (player.global_position-enemy.global_position
	).rotated(deg_to_rad(90*enemy.idle_direction)).normalized()*enemy.speed/4


func _on_player_range_area_entered(_area):
	if parry_timer.is_stopped() and dash_timer.is_stopped():
		parry_timer.start()
		feint_timer.start()
		parry_der.start()
		enemy.parrying = true


func _on_feint_timeout():
	if not enemy.parried:
		dash_timer.start()
		$"..".overide_state("p2_d_dash")
	else:
		enemy.parried = false
	
	pass
