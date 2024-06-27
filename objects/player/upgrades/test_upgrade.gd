extends Node
class_name double_health


#var player = get_tree().get_nodes_in_group("Player")[0]
var part_sprite = null
var title = "Double Health"
var discription = """Doubles your max health and your current health
(You will keep your health percentage)"""


func affect():
	Tracker.player_health *=2
	Tracker.player_max_health *= 2
