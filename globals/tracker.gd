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


var totorial_level = "res://levels/levels fr fr og/intro room.tscn"
var first_levels = [
	"res://levels/levels fr fr og/first_levels/rm3.tscn",
	"res://levels/levels fr fr og/first_levels/rm4.tscn",
	"res://levels/levels fr fr og/first_levels/rm5.tscn",
	"res://levels/levels fr fr og/first_levels/rm6.tscn",
	"res://levels/levels fr fr og/first_levels/rm7.tscn",
	"res://levels/levels fr fr og/first_levels/rm8.tscn"
]
var second_levels = [
	"res://levels/levels fr fr og/first_levels/rm3.tscn",
	"res://levels/levels fr fr og/first_levels/rm4.tscn",
	"res://levels/levels fr fr og/first_levels/rm5.tscn",
	"res://levels/levels fr fr og/first_levels/rm6.tscn",
	"res://levels/levels fr fr og/first_levels/rm7.tscn",
	"res://levels/levels fr fr og/first_levels/rm8.tscn"
]
var third_levels = [
	"res://levels/levels fr fr og/first_levels/rm3.tscn",
	"res://levels/levels fr fr og/first_levels/rm4.tscn",
	"res://levels/levels fr fr og/first_levels/rm5.tscn",
	"res://levels/levels fr fr og/first_levels/rm6.tscn",
	"res://levels/levels fr fr og/first_levels/rm7.tscn",
	"res://levels/levels fr fr og/first_levels/rm8.tscn"
]
var boss_levels = ["res://levels/levels fr fr og/boss_room.tscn"]
var win_screen = "res://Menus/win/win_screen.tscn"
var boss_intro_file = "res://Menus/boss/boss_enter.tscn"

var level_next
var difficulty = "easy"

#need to be reset
var default_health
var current_level_level
var player_health
var player_max_health
var player_speed
var player_knockback_res
var player_damage
var player_knockback
var player_damage_res
var player_attack_cooldown
var player_dash_cooldown
var player_parry_cooldown

var num_enemies
var go_next_level

#enemies
var enemy_speed
var enemy_attack_cooldown
var enemy_health

#barrels
var barrel_health_chance = [1, 10]
var barrel_pool:Array


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
		if current_level_level == 4:
			boss_intro()
		elif current_level_level == 5:
			next_level()
		else:
			start_part_pick()


func start_level():
	#activate spawners
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


func start_part_pick():
	get_tree().change_scene_to_file("res://Menus/parts/pick_part.tscn")


func next_level():
	match difficulty:
		"easy":
			player_health += 10
		"normal", "hard":
			player_health += 5
		"veryHard":
			player_health += 4
	
	if player_health > player_max_health:
		player_health = player_max_health
	
	get_tree().change_scene_to_file(level_next)


func boss_intro():
	get_tree().change_scene_to_file(boss_intro_file)


func trigger_next_level():
	SpeedrunTimer.new_split()
	
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
	if player_max_health > default_health: #If the player got a more health upgrade
		player_health /= 2
	elif player_max_health < default_health: #If the player got a less health upgrade
		player_health *= 2
	
	player_max_health = default_health
	
	player_speed = 100
	player_knockback_res = 1
	player_knockback = 1000
	player_attack_cooldown = 1.0
	player_dash_cooldown = 1.0
	player_parry_cooldown = 1.0
	
	player_damage = 3
	if difficulty == "easy":
		player_damage_res = 1
	elif difficulty == "normal" or difficulty == "one shot":
		player_damage_res = 0
	elif difficulty == "hard" or "veryHard":
		player_damage_res = -1


func reset():
	match difficulty:
		"easy":
			default_health = 30
			barrel_health_chance = [1,5]
			enemy_speed = 0.6
			enemy_attack_cooldown = 0.6
			enemy_health = 0.6
		"normal":
			default_health = 25
			barrel_health_chance = [1, 10]
			enemy_speed = 0.8
			enemy_attack_cooldown = 0.8
			enemy_health = 0.8
		"hard":
			default_health = 25
			barrel_health_chance = [1, 15]
			enemy_speed = 1
			enemy_attack_cooldown = 1
			enemy_health = 1
		"veryHard":
			default_health = 20
			barrel_health_chance = [1, 20]
			enemy_speed = 1.2
			enemy_attack_cooldown = 1.2
			enemy_health = 1.2
		"one shot":
			default_health = 1
			barrel_health_chance = [1, 20]
			enemy_speed = 1
			enemy_attack_cooldown = 1
			enemy_health = 1
	
	reset_barrel_pool()
	
	player_max_health = default_health
	player_health = default_health
	
	SpeedrunTimer.reset()
	
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


func reset_barrel_pool():
	if barrel_health_chance[0] > barrel_health_chance[1]:
		push_error("Bad barrel chance values: " + str(barrel_health_chance[0])+" and "+str(barrel_health_chance[1]))
		
	barrel_pool = []
	for x in barrel_health_chance[1]:
		barrel_pool.append(false)
	
	while barrel_pool.count(true) < barrel_health_chance[0]:
		var index = rng.randi_range(0, len(barrel_pool)-1)
		if not barrel_pool[index]:
			barrel_pool[index] = true


func get_barrel_loot():
	if not len(barrel_pool):
		reset_barrel_pool()
	
	return barrel_pool.pop_back()
