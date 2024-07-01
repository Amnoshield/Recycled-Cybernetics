extends State
class_name p2_d_idle

@onready var enemy:CharacterBody2D = $"../.."
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var parry_timer = $"../../player_range/parry_cooldown"
@onready var parry_der = $"../../player_range/parry_deration"
@onready var dash_timer = $"../../dash_cooldown"
@onready var feint_timer = $"../../feint"
@onready var agro = $"../agro"
var one = false
var rng = RandomNumberGenerator.new()


func Enter():
	enemy.idle_direction = enemy.change_idle_dir()
	one = false
	agro.start(rng.randi_range(3, 6))


func Physics_Update(_delta):
	enemy.velocity = (player.global_position-enemy.global_position
	).rotated(deg_to_rad(90*enemy.idle_direction)).normalized()*enemy.speed/4


func _on_player_range_area_entered(_area):
	if $"..".current_state != self:
		return
	
	if parry_timer.is_stopped() and dash_timer.is_stopped():
		feint_timer.start()
		trigger_parry()
	elif parry_timer.is_stopped():
		if rng.randi_range(1, 4) == 1:
			one = "parry"
			feint_timer.start()
		else:
			trigger_parry()
			Transitioned.emit(self, "p2_po_pathfind")
			
	elif dash_timer.is_stopped():
		if rng.randi_range(1, 4) == 1:
			one = "dash"
			feint_timer.start()
		else:
			trigger_dash()


func _on_feint_timeout():
	if $"..".current_state != self:
		return
	
	if not one:
		if not enemy.parried:
			trigger_dash()
		else:
			Transitioned.emit(self, "p2_po_pathfind")
			enemy.parried = false
	else:
		if one == 'parry':
			trigger_parry()
			Transitioned.emit(self, "p2_po_pathfind")
		else:
			trigger_dash()
			
	
	pass

func trigger_parry():
	parry_timer.start()
	parry_der.start()
	enemy.parrying = true

func trigger_dash():
	dash_timer.start()
	$"..".overide_state("p2_d_dash")


func _on_agro_timeout():
	if $"..".current_state != self:
		return
	
	Transitioned.emit(self, "p2_po_pathfind")
