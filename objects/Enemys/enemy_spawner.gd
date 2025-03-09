extends Node2D

@onready var ray = $RayCast2D
@onready var minimap = get_tree().get_nodes_in_group("minimap")[0]
@export var enemies:Array[PackedScene]
var spawnable = false
var near_spawners = []
var rng = RandomNumberGenerator.new()
var enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	enemy = enemies[rng.randi_range(0, len(enemies)-1)]
	if enemy:
		Tracker.num_enemies += 1
	
	add()


func spawn():
	if not spawnable:
		return
	
	if enemy:
		enemy = enemy.instantiate()
		enemy.global_position = global_position
		get_node("..").add_child(enemy)
	
	spawnable = false
	#call_deferred_thread_group("trigger")
	trigger()
	remove()


func trigger():
	for spawner in near_spawners:
		spawner.spawn()


func _on_visible_on_screen_notifier_2d_screen_entered():
	call_deferred_thread_group("spawn")
	#spawn()


func _on_area_2d_area_entered(area:Area2D):
	ray.target_position = area.global_position - global_position
	ray.force_raycast_update()
	if not ray.is_colliding():
		near_spawners.append(area.get_parent())


func add():
	Tracker.spawners.append(self)
	if enemy:
		minimap.add_tracker(self)
		Tracker.enemy_counter.change_label(Tracker.num_enemies)


func remove():
	if enemy:
		minimap.remove_tracker(self)
	
	Tracker.spawners.erase(self)
	self.queue_free()
