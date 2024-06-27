extends Node


var num_enemies = 0
var spawners:Array = []
var end
var rng = RandomNumberGenerator.new()
var upgrades = ["res://objects/player/upgrades/test_upgrade.gd"]
var chosen_upgrades = []


var totorial_level = "res://levels/test_scene.tscn"
var first_levels = ["res://levels/test_scene.tscn"]
var second_levels = ["res://levels/test_scene.tscn"]
var third_levels = ["res://levels/test_scene.tscn"]
var boss_levels = ["res://levels/test_scene.tscn"]
var win_screen = "res://Menus/win_screen.tscn"


#need to be reset
var current_level_level = 1
var player_health = 10
var player_max_health = 10
var go_next_level = false


func _ready():
	var counter = 0
	while counter < len(upgrades):
		upgrades[counter] = load(upgrades[counter])		
		counter += 1


func _process(_delta):
	if go_next_level:
		go_next_level = false
		next_level()


func spawn_enemies():
	for enemy in spawners:
		enemy.spawnable = true


func remove_enemy():
	num_enemies -= 1
	
	if num_enemies <= 0 and is_instance_valid(end):
		end.open()
	elif num_enemies <= 0:
		print('Idk man')


func next_level():
	if current_level_level == 1:#tutorial
		get_tree().change_scene_to_file(totorial_level)
	elif current_level_level == 2:#level 1
		var _min = 0
		var _max = len(first_levels)-1
		var level = first_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	elif current_level_level == 3:#level 2
		var _min = 0
		var _max = len(second_levels)-1
		var level = second_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	elif current_level_level == 4:#level 3
		var _min = 0
		var _max = len(third_levels)-1
		var level = third_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	elif current_level_level == 5:#Boss
		var _min = 0
		var _max = len(boss_levels)-1
		var level = boss_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	else:#Win screen
		get_tree().change_scene_to_file(win_screen)
	
	current_level_level += 1


func trigger_next_level():
	go_next_level = true


func reset():
	current_level_level = 1
	player_health = 10
	player_max_health = 10
	go_next_level = false


func get_upgrade(idx:int, buff:bool):
	var upgrade = upgrades.pop_at(idx)
	chosen_upgrades.append({"obj":upgrade, "name":upgrade.name})


func apply_upgrades():
	for upgrade in chosen_upgrades:
		upgrade["obj"].affect()
