extends Node


var spawners:Array = []
var end
var enemy_counter
var rng = RandomNumberGenerator.new()
var next_upgrade = false
var upgrades = []
var chosen_upgrades = []
var upgrades_main:Array = [
	["res://objects/player/upgrades/double_health.gd", "res://objects/player/upgrades/half_health.gd"],
	["res://objects/player/upgrades/double_attack_speed.gd", "res://objects/player/upgrades/half_attack_speed.gd"],
	["res://objects/player/upgrades/half_parry_cooldown.gd", "res://objects/player/upgrades/double_parry_cooldown.gd"],
	["res://objects/player/upgrades/half_dash_cooldown.gd", "res://objects/player/upgrades/double_dash_cooldown.gd"],
	["res://objects/player/upgrades/double_damage.gd", "res://objects/player/upgrades/half_damage.gd"],
	["res://objects/player/upgrades/double_knockback_res.gd", "res://objects/player/upgrades/half_knockback_res.gd"],
	["res://objects/player/upgrades/double_speed.gd", "res://objects/player/upgrades/half_speed.gd"],
	["res://objects/player/upgrades/more_damage_res.gd", "res://objects/player/upgrades/less_damage_res.gd"],
	["res://objects/player/upgrades/double_knockback.gd", "res://objects/player/upgrades/half_knockback.gd"]
]


var totorial_level = "res://levels/levels fr fr og/test_scene.tscn"
var first_levels = ["res://levels/levels fr fr og/test_scene.tscn"]
var second_levels = ["res://levels/levels fr fr og/test_scene.tscn"]
var third_levels = ["res://levels/levels fr fr og/test_scene.tscn"]
var boss_levels = ["res://levels/levels fr fr og/boss_room.tscn"]
var win_screen = "res://Menus/win_screen.tscn"

var level_next

#need to be reset
var current_level_level
var player_health
var player_max_health
var player_speed
var player_knockback_res
var player_dash_cooldown
var player_attack_cooldown
var player_damage
var player_knockback
var player_parry_cooldown
var player_damage_res

var num_enemies
var go_next_level


func _ready():
	var counter = 0
	while counter < len(upgrades_main):
		upgrades_main[counter][0] = load(upgrades_main[counter][0]).new()
		upgrades_main[counter][1] = load(upgrades_main[counter][1]).new()
		counter += 1
	
	reset()


func _process(_delta):
	if go_next_level:
		go_next_level = false
		if current_level_level > 4:
			next_level()
		else:
			start_next_level()


func spawn_enemies():
	for enemy in spawners:
		if is_instance_valid(enemy):
			enemy.spawnable = true
		else:
			print("stale spawner")
	spawners.clear() #Idk if this does anyhting but a crach happend related to this so just in case


func remove_enemy(enemy):
	if not is_instance_valid(enemy): return
	
	num_enemies -= 1
	
	enemy_counter.change_label(num_enemies)
	
	if num_enemies <= 0 and is_instance_valid(end):
		end.open()
	elif num_enemies <= 0:
		print("end not valid")


func start_next_level():
	get_tree().change_scene_to_file("res://Menus/pick_part.tscn")


func next_level():
	get_tree().change_scene_to_file(level_next)


func trigger_next_level():
	go_next_level = true
	current_level_level += 1
	if current_level_level == 1:#level 1
		var _min = 0
		var _max = len(first_levels)-1
		level_next = first_levels[rng.randi_range(_min, _max)]
	elif current_level_level == 2:#level 2
		var _min = 0
		var _max = len(second_levels)-1
		level_next = second_levels[rng.randi_range(_min, _max)]
	elif current_level_level == 3:#level 3
		var _min = 0
		var _max = len(third_levels)-1
		level_next = third_levels[rng.randi_range(_min, _max)]
	elif current_level_level == 4:#Boss
		var _min = 0
		var _max = len(boss_levels)-1
		level_next = boss_levels[rng.randi_range(_min, _max)]
	else:#Win screen
		level_next = win_screen


func player_reset():
	if player_max_health > 20: #If the player got a more health upgrade
		player_health /= 2
	elif player_max_health < 20: #If the player got a less health upgrade
		player_health *= 2
	
	player_max_health = 20
	
	player_speed = 100
	player_knockback_res = 1
	player_dash_cooldown = 1.
	player_attack_cooldown = 1.
	player_damage = 2
	player_knockback = 1000
	player_parry_cooldown = 1.
	player_damage_res = 0


func reset():
	player_max_health = 20
	player_health = 20
	
	player_reset()
	
	num_enemies = 0
	next_upgrade = false
	current_level_level = 0
	go_next_level = false
	
	
	chosen_upgrades.clear()
	for upgrade in upgrades_main:
		if upgrade not in upgrades:
			upgrades.append(upgrade)


func get_upgrade(idx1:int, idx2:int):
	next_upgrade = upgrades.pop_at(idx1)[idx2]
	chosen_upgrades.append({"obj":next_upgrade, "name":next_upgrade.name, 'des':next_upgrade.discription})
	next_level()


func apply_upgrade(entity):
	if next_upgrade:
		next_upgrade.affect(entity)


func apply_upgrades(entity):
	for upgrade in chosen_upgrades:
		upgrade["obj"].affect(entity)
