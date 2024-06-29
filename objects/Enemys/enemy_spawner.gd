extends Node2D

@onready var ray = $RayCast2D
@onready var minimap = get_tree().get_nodes_in_group("minimap")[0]
@export var enemies:Array[PackedScene] = [null]
var spawnable = false
var near_spawners = []
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	Tracker.num_enemies += 1
	add()


func spawn():
	if not spawnable:
		return
	var mob:Node = enemies[rng.randi_range(0, len(enemies)-1)].instantiate()
	mob.global_position = global_position
	get_node("..").add_child(mob)
	spawnable = false
	trigger()
	remove()


func trigger():
	for spawner in near_spawners:
		spawner.spawn()


func _on_visible_on_screen_notifier_2d_screen_entered():
	spawn()


func _on_area_2d_area_entered(area:Area2D):
	ray.target_position = area.global_position - global_position
	ray.force_raycast_update()
	if not ray.is_colliding():
		near_spawners.append(area.get_parent())


func add():
	Tracker.spawners.append(self)
	minimap.add_tracker(self)


func remove():
	Tracker.spawners.erase(self)
	minimap.remove_tracker(self)
	self.queue_free()
