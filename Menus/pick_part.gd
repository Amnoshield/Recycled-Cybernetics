extends Node2D

var rng = RandomNumberGenerator.new()
var parts = []
var part_templates = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in range(3):
		part_templates.append(load("res://Menus/part template.tscn").instantiate())
		part_templates[-1].global_position = Vector2(288*x+288, 324)
		self.add_child(part_templates[-1])
	
	var _min = 0
	var _max = len(Tracker.upgrades)-1
	while len(parts) < 3 and len(Tracker.upgrades) != len(parts):
		var part_number = rng.randi_range(_min, _max)
		if part_number not in parts:
			parts.append(part_number)
	
	
	for part_idx in part_templates.size():
		if part_idx > len(parts)-1: break
		var temp_part = Tracker.upgrades[parts[part_idx]]
		part_templates[part_idx].setup(temp_part.title, temp_part.part_sprite, temp_part.discription, temp_part.background_sprite, parts[part_idx])


