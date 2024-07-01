extends SubViewport

@onready var camera = $Camera2D
@onready var player:CharacterBody2D = get_tree().get_nodes_in_group("Player")[0]
@onready var source = get_tree().get_nodes_in_group("walls")[0]
@onready var player_icon = $Player

@export var tracker_texture:PackedScene

var tracker_pos = {}


func _ready():
	var temp = source.duplicate(2)
	add_child(temp)
	$"..".modulate.a = 0.8


func _physics_process(_delta):
	camera.position = player.position
	player_icon.position = camera.position


func add_tracker(tracke:Node):
	Tracker.enemy_counter = $"../../../enemy counter/Label"
	Tracker.enemy_counter.change_label(Tracker.num_enemies)
	var tracker = tracker_texture.instantiate()
	tracker.position = tracke.global_position
	tracker_pos[tracke.global_position] = tracker

	add_child(tracker)


func remove_tracker(tracke):
	tracker_pos[tracke.global_position].queue_free()


func invis():
	$"../../..".visible = false


func vis():
	$"../../..".visible = true
