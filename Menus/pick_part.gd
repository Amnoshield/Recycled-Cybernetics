extends Node2D

@onready var part1 = $parts/PartTemplate
@onready var part2 = $parts/PartTemplate2
@onready var part3 = $parts/PartTemplate3

var rng = RandomNumberGenerator.new()
var parts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var _min = 0
	var _max = len(Tracker.upgrades)-1
	while len(parts) < 3:
		var part_number = rng.randi_range(_min, _max)
		if part_number not in parts:
			parts.append(part_number)
	
	part1
	

