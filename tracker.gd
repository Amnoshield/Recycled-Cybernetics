extends Node


var num_enemies = 0
var enemies = []
var end = null
var rng = RandomNumberGenerator.new()


var first_levels = ["res://levels/test_scene.tscn"]
var second_levels = ["res://levels/test_scene.tscn"]
var third_levels = ["res://levels/test_scene.tscn"]
var boss_levels = ["res://levels/test_scene.tscn"]
var win_screen = "res://Menus/win_screen.tscn"

#need to be reset
var current_level_level = 1
var player_health = 10
var player_max_health = 10

func spawn_enemies():
	for enemy in enemies:
		enemy.spawnable = true
	enemies.clear()


func remove_enemy():
	num_enemies -= 1
	
	if num_enemies <= 0:
		end.open()


func next_level():
	if current_level_level == 1:
		var _min = 0
		var _max = len(first_levels)-1
		var level = first_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	elif current_level_level == 2:
		var _min = 0
		var _max = len(second_levels)-1
		var level = second_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	elif current_level_level == 3:
		var _min = 0
		var _max = len(third_levels)-1
		var level = third_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	elif current_level_level == 4:
		var _min = 0
		var _max = len(boss_levels)-1
		var level = boss_levels[rng.randi_range(_min, _max)]
		get_tree().change_scene_to_file(level)
	else:
		get_tree().change_scene_to_file(win_screen)
	
	current_level_level += 1


func reset():
	current_level_level = 1
	player_health = 10
	player_max_health = 10

